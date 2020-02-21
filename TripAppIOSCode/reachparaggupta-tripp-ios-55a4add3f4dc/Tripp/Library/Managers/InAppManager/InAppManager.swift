//
//  InAppManager.swift
//  Tripp
//
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import StoreKit

typealias InApManagerHandler = (_ success: Bool,_ error: Error?) -> Void

struct ProductIdentifier {
    static let oneMonth = "com.tripps.Tripp.onemonthsubscription"
    static let threeMonth = "com.tripps.Tripp.threemonthsubscription"
    static let placesCategory = "com.tripps.Tripp.placecategory"
}

class InAppManager: NSObject {
    
    struct Keys {
        static let userId = "InApp_user_id"
        static let product_id = "product_id"
        static let transaction_id = "transaction_id"
        static let purchase_date = "purchase_date"
        static let expires_date = "expires_date"
    }
    
    static let sharedManger = InAppManager()
    static let iTuneSharedSecret = "42d11b1240f744cb84feb4d2c7d87096"
    
    
    var handler: InApManagerHandler?
    var products: [SKProduct] = [SKProduct]()
    fileprivate var purchaseIdentifier: String = ProductIdentifier.oneMonth
    fileprivate var isReceiptValidation = false
    private var inSandbox = false
    
    func initialize(_ delegate: SKPaymentTransactionObserver) {
        SKPaymentQueue.default().add(delegate)
    }
    
    func startPurchaseWith(identifier: String, handler: @escaping InApManagerHandler) {
        self.handler = handler
        self.purchaseIdentifier = identifier
        self.requestPaymentInfo(self.purchaseIdentifier)
    }
    
    public func restorePurchases(handler: @escaping InApManagerHandler) {
        self.handler = handler
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchProducts(handler: @escaping InApManagerHandler) {
        self.handler = handler
        if (SKPaymentQueue.canMakePayments()) {
            let productIdentifiers: NSSet = NSSet(array: [ProductIdentifier.oneMonth, ProductIdentifier.threeMonth, ProductIdentifier.placesCategory])
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
        } else {
            let error = NSError(domain: "INAPPERROR", code: -1023, userInfo: [NSLocalizedDescriptionKey: "In App purchase not enable to your application."])
            self.handler?(false, error as Error)
        }
    }
    
    private func requestPaymentInfo(_ identifier: String) {
        if (SKPaymentQueue.canMakePayments()) {
            let productIdentifiers: NSSet = NSSet(array: [identifier])
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
        } else {
            let error = NSError(domain: "INAPPERROR", code: -1023, userInfo: [NSLocalizedDescriptionKey: "In App purchase not enable to your application."])
            self.handler?(false, error as Error)
        }
    }
    
    func makePaymentOfProduct(_ product: SKProduct, handler: @escaping InApManagerHandler) {
        self.handler = handler
        self.purchaseIdentifier = product.productIdentifier
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
}

extension InAppManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            self.products = response.products
            self.handler?(true, nil)
        } else {
            let error = NSError(domain: "INAPPERROR", code: -1023, userInfo: [NSLocalizedDescriptionKey: "Invalid product identifier."])
            self.handler?(false, error as Error)
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        self.handler?(false, error)
    }
    
}

extension InAppManager {
    
    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func verifyInAppReceipt(_ isSandbox:Bool = false) {
        self.inSandbox = isSandbox
        if let data = loadReceipt(), isReceiptValidation == false {
            let body = [
                "receipt-data": data.base64EncodedString(),
                "password": InAppManager.iTuneSharedSecret
            ]
            
            let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
            let receiptUrl = inSandbox == true ? "https://sandbox.itunes.apple.com/verifyReceipt" : "https://buy.itunes.apple.com/verifyReceipt"
            let url = URL(string: receiptUrl)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = bodyData
            isReceiptValidation = true
            let task = URLSession.shared.dataTask(with: request) { [weak self] (responseData, response, error) in
                if let error = error {
                    print(error)
                    // Receipt was from Sandbox
                    if (error as NSError).code == 21007 {
                        // Switch to using the Sandbox server here on out
                        // Restart validation
                        self?.verifyInAppReceipt(true)
                    } else {
                        InAppManager.sharedManger.handler?(false, error)
                    }
                } else if let responseData = responseData {
                    self?.parseReceiptData(responseData)
                }
                self?.isReceiptValidation = false
            }
            task.resume()
        }
    }
    
    func parseReceiptData(_ data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let latestReceiptInfo = json?["latest_receipt_info"] as? [[String: Any]], let first = latestReceiptInfo.last {
                UserDefaults.standard.set(AppUser.sharedInstance?.userId ?? 0, forKey: Keys.userId)
                if let value = first[Keys.product_id] as? String {
                    UserDefaults.standard.set(value, forKey: Keys.product_id)
                }
                if let value = first[Keys.transaction_id] as? String {
                    UserDefaults.standard.set(value, forKey: Keys.transaction_id)
                }
                if let value = first[Keys.purchase_date] as? String {
                    UserDefaults.standard.set(value.replacingOccurrences(of: "Etc/GMT", with: "GMT"), forKey: Keys.purchase_date)
                }
                if let value = first[Keys.expires_date] as? String {
                    UserDefaults.standard.set(value.replacingOccurrences(of: "Etc/GMT", with: "GMT"), forKey: Keys.expires_date)
                }
                UserDefaults.standard.set(AppUser.sharedInstance?.userId, forKey: Keys.userId)
                UserDefaults.standard.synchronize()
                InAppManager.sharedManger.handler?(true, nil)
            } else if (json!["status"] as! Int) == 21007 {
                // Switch to using the Sandbox server here on out
                // Restart validation
                isReceiptValidation = false
                self.verifyInAppReceipt(true)
            } else {
                InAppManager.sharedManger.handler?(false, NSError(domain: "INAPPERROR", code: 5987, userInfo: [NSLocalizedDescriptionKey: "Invalid receipt data."]))
            }
        } else {
            InAppManager.sharedManger.handler?(false, NSError(domain: "INAPPERROR", code: 5987, userInfo: [NSLocalizedDescriptionKey: "Receipt not found"]))
        }
    }
}

extension AppDelegate: SKPaymentTransactionObserver {
    
    private func completeTransaction(status: Bool, error: Error?, transaction: SKPaymentTransaction) {
        if status == true {
            if InAppManager.sharedManger.purchaseIdentifier == ProductIdentifier.placesCategory {
                InAppManager.sharedManger.handler?(true, nil)
            } else {
                InAppManager.sharedManger.verifyInAppReceipt()
            }
        } else {
            InAppManager.sharedManger.handler?(status, error)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                completeTransaction(status: true, error: nil, transaction: transaction)
                    print("purchased")
                break
            case .failed:
                completeTransaction(status: false, error: transaction.error, transaction: transaction)
                print("failed")
                break
            case .restored:
                completeTransaction(status: true, error: nil, transaction: transaction)
                print("restored")
                break
            case .deferred:
                print("deferred")
                break
            case .purchasing:
                print("purchasing")
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        InAppManager.sharedManger.handler?(false, error)
    }
    
}
