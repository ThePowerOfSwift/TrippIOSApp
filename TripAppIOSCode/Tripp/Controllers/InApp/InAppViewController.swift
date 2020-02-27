//
//  InAppViewController.swift
//  Tripp
//
//  Created by Monu on 06/07/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import StoreKit

enum InAppCell: String {
    case cellFree
    case cellOneMonth
    case cellThreeMonth
}

class InAppViewController: UIViewController, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var termsConditionsLabel: TTTAttributedLabel!
    
    @IBOutlet weak var starterButton: UIButton!
    @IBOutlet weak var proButton: UIButton!
    @IBOutlet weak var proPlusButton: UIButton!
    @IBOutlet weak var planDescription: UILabel!
    @IBOutlet weak var subscribeButton: RoundedBorderButton!
    @IBOutlet weak var starterAmountLabel: UILabel!
    @IBOutlet weak var proAmountLabel: UILabel!
    @IBOutlet weak var proPlusAmountLabel: UILabel!
    @IBOutlet weak var currentPlanLabel: UILabel!
    
    var selectedPlanIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupView() {
        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableViewAutomaticDimension
        self.restoreButton.isHidden = AppUser.sharedInstance?.subscription() == .subscribed
        setupTermsLabel()
        setupInAppDetails()
        subscribeButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 25)
    }
    
    private func showPlanDetail(_ index: Int) {
        if index == 0 {
            planDescription.text = "\u{2055} Be a part of any group.\n\u{2055} View other group members."
        } else {
            planDescription.text = "\u{2055} Create a group.\n\u{2055} No Advertisements.\n\u{2055} Invite friends and family to group.\n\u{2055} View group members, profile and trips"
        }
    }
    
    private func setupInAppDetails() {
        let productOneMonth = InAppManager.sharedManger.products.filter({$0.productIdentifier == ProductIdentifier.oneMonth}).first
        let productThreeMonth = InAppManager.sharedManger.products.filter({$0.productIdentifier == ProductIdentifier.threeMonth}).first
        starterAmountLabel.text = (productOneMonth?.priceLocale.currencySymbol ?? "$") + "0.0"
        proAmountLabel.text = productOneMonth?.priceOfProduct()
        proPlusAmountLabel.text = productThreeMonth?.priceOfProduct()
        proPlusButton.layer.borderWidth = 4.0
        proButton.layer.borderWidth = 4.0
        starterButton.layer.borderWidth = 4.0
        
        if AppUser.sharedInstance?.subscription() == .subscribed, let prodictId = UserDefaults.standard.value(forKey: "product_id") as? String {
            subscribeButton.isHidden = true
            currentPlanLabel.isHidden = false
            if prodictId == ProductIdentifier.threeMonth {
                selectPlanWithIndex(2)
            } else {
                selectPlanWithIndex(1)
            }
        } else {
            selectPlanWithIndex(0)
        }
    }
    
    private func setupTermsLabel() {
        let text = inAppTerms
        
        let attributedString = String.createAttributedString(text: text, font: UIFont.openSensRegular(size: 12), color: UIColor.darkGray, spacing: -0.4)
        
        let linkAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.blueButtonColor(),
            NSAttributedStringKey.font: UIFont.openSensRegular(size: 14),
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
            ] as [NSAttributedStringKey : Any]
        
        termsConditionsLabel.delegate = self
        termsConditionsLabel.numberOfLines = 0
        termsConditionsLabel.textAlignment = NSTextAlignment.center
        termsConditionsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        termsConditionsLabel.textInsets = .zero
        termsConditionsLabel.setText(attributedString)
        termsConditionsLabel.linkAttributes = linkAttributes
        termsConditionsLabel.activeLinkAttributes = linkAttributes
        
        let termsConditionRange = (text as NSString).range(of:termsAndConditions)
        let termsConditionUrl = NSURL(string: LinkTapEvent.termsAndConditionEvent)
        termsConditionsLabel.addLink(to: termsConditionUrl as URL!, with:termsConditionRange)
        
        let privacyPolicyRange = (text as NSString).range(of:privacyPolicy)
        let privacyPolicyUrl = NSURL(string: LinkTapEvent.privacyPolicyEvent)
        termsConditionsLabel.addLink(to: privacyPolicyUrl as URL!, with:privacyPolicyRange)
        
        termsConditionsLabel.isUserInteractionEnabled = true
        
    }
    
    @IBAction func selectPlanButtonTapped(_ sender: UIButton) {
        selectPlanWithIndex(sender.tag)
    }
    
    private func selectPlanWithIndex(_ index: Int) {
        proPlusButton.layer.borderColor = UIColor.clear.cgColor
        proButton.layer.borderColor = UIColor.clear.cgColor
        starterButton.layer.borderColor = UIColor.clear.cgColor
        selectedPlanIndex = index
        showPlanDetail(index)
        if index == 0 {
            starterButton.layer.borderColor = UIColor.appBlueColor(withAlpha: 1.0).cgColor
            subscribeButton.isHidden = true
            currentPlanLabel.isHidden = false
        } else if index == 1 {
            proButton.layer.borderColor = UIColor.appBlueColor(withAlpha: 1.0).cgColor
            subscribeButton.isHidden = false
            currentPlanLabel.isHidden = true
        } else {
            proPlusButton.layer.borderColor = UIColor.appBlueColor(withAlpha: 1.0).cgColor
            subscribeButton.isHidden = false
            currentPlanLabel.isHidden = true
        }
        
        if AppUser.sharedInstance?.subscription() == .subscribed, let prodictId = UserDefaults.standard.value(forKey: "product_id") as? String {
            if index == 1, prodictId == ProductIdentifier.oneMonth {
                subscribeButton.isHidden = true
                currentPlanLabel.isHidden = false
            } else if index == 2, prodictId == ProductIdentifier.threeMonth {
                subscribeButton.isHidden = true
                currentPlanLabel.isHidden = false
            } else if index == 0 {
                subscribeButton.isHidden = true
                currentPlanLabel.isHidden = true
            }
        }
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        if selectedPlanIndex == 1 {
            let product = InAppManager.sharedManger.products.filter({$0.productIdentifier == ProductIdentifier.oneMonth}).first
            startPurchaseWithIdentifier(product)
        } else if selectedPlanIndex == 2 {
            let product = InAppManager.sharedManger.products.filter({$0.productIdentifier == ProductIdentifier.threeMonth}).first
            startPurchaseWithIdentifier(product)
        }
    }
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        AppLoader.showLoader()
        InAppManager.sharedManger.restorePurchases { [weak self] (status, error) in
            DispatchQueue.main.async {
                AppLoader.hideLoader()
                if status == true {
                    self?.restoreButton.isHidden = AppUser.sharedInstance?.subscription() == .subscribed
                    self?.setupInAppDetails()
                } else {
                    AppToast.showErrorMessage(message: error?.localizedDescription ?? someErrorMessage);
                }
            }
        }
    }
    
    private func startPurchaseWithIdentifier(_ product: SKProduct?) {
        guard let purchasedProduct = product else { return }
        AppLoader.showLoader()
        InAppManager.sharedManger.makePaymentOfProduct(purchasedProduct) { [weak self] (status, error) in
            DispatchQueue.main.async {
                AppLoader.hideLoader()
                if status == true {
                    self?.restoreButton.isHidden = AppUser.sharedInstance?.subscription() == .subscribed
                    self?.setupInAppDetails()
                } else {
                    AppToast.showErrorMessage(message: error?.localizedDescription ?? someErrorMessage);
                }
            }
        }
    }
    
    //MARK: ------------------- Delegates  --------------------
    
    //MARK: TTTAttributedLabelDelegate
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        if let url = url {
            if url.absoluteString == LinkTapEvent.termsAndConditionEvent {
                self.pushAppWebView(type: .termsAndConditions, presentView: true)
            } else if url.absoluteString == LinkTapEvent.privacyPolicyEvent {
                self.pushAppWebView(type: .privacyPolicy, presentView: true)
            }
        }
    }
    
}

extension InAppViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "InAppPurchaseCell", for: indexPath)
    }
}

extension SKProduct {
    func priceOfProduct() -> String? {
        if let currency = self.priceLocale.currencySymbol {
            return String(format: "%@%0.2f", currency, self.price.doubleValue)
        } else {
            return nil
        }
    }
}
