//
//  CategoryIAPViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 02/10/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
protocol CategoryPurchaseProtocol: class {
    func categoryDidPurchased()
}

class CategoryIAPViewController: UIViewController {
    var category: PlaceCategory!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var purchaseButton: RoundedBorderButton!
    weak var delegate: CategoryPurchaseProtocol?
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Private
    private func setupView() {
        titleLabel.text = category.name
        categoryImageView.imageFromS3(category.image ?? "") { [weak self] (image) in
            self?.categoryImageView.image = image
        }
        purchaseButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 25)
        let product = InAppManager.sharedManger.products.filter({$0.productIdentifier == ProductIdentifier.placesCategory}).first
        priceLabel?.text = product?.priceOfProduct() ?? "$4.99"
    }
    private func markCategoryAsPurchased() {
        APIDataSource.purchaseCategory(service: .purchaseCategory(placeCategoryId: category.categoryId)) { (_, _) in
            //nothing to do here
        }
    }
    //MARK:- IBActions
    @IBAction func nothanksTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func purchaseTapped(_ sender: Any) {
        let product = InAppManager.sharedManger.products.filter({$0.productIdentifier == ProductIdentifier.placesCategory}).first
        guard let purchasedProduct = product else { return }
        AppLoader.showLoader()
        InAppManager.sharedManger.makePaymentOfProduct(purchasedProduct) { [weak self] (status, error) in
            DispatchQueue.main.async {
                AppLoader.hideLoader()
                if status == true {
                    AppToast.showSuccessMessage(message: "successfully purchased the category.")
                    self?.category.isPurchased = 1
                    self?.markCategoryAsPurchased()
                    self?.dismiss(animated: true, completion: {
                        self?.delegate?.categoryDidPurchased()
                    })
                } else {
                    AppToast.showErrorMessage(message: error?.localizedDescription ?? someErrorMessage);
                }
            }
        }
    }
    @IBAction func restoreTapped(_ sender: Any) {
        AppLoader.showLoader()
        InAppManager.sharedManger.restorePurchases { [weak self] (status, error) in
            DispatchQueue.main.async {
                AppLoader.hideLoader()
                if status == true {
                    AppToast.showSuccessMessage(message: "successfully restored your purchase.")
                    self?.category.isPurchased = 1
                   // self?.markCategoryAsPurchased()
                    self?.dismiss(animated: true, completion: {
                        self?.delegate?.categoryDidPurchased()
                    })
                } else {
                    AppToast.showErrorMessage(message: error?.localizedDescription ?? someErrorMessage);
                }
            }
        }
    }
}
