//
//  RouteDetailsViewController.swift
//  Tripp
//
//  Created by Monu on 17/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMobileAds

class RouteDetailsViewController: BaseViewController, GMSMapViewDelegate, PopupActionDelegate {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var routeDetailsTable: UITableView!
    @IBOutlet weak var addToMyTripsButton: RoundedBorderButton!
    @IBOutlet weak var routeNameLabel: UILabel!
    
    @IBOutlet weak var routeDetailsView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //-- Route Details View
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: CharacterSpaceLabel!
    @IBOutlet weak var roadTypeLabel: CharacterSpaceLabel!
    @IBOutlet weak var roadLevelLabel: CharacterSpaceLabel!
    @IBOutlet weak var detailsLabel: CharacterSpaceLabel!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var curvinessLabel: UILabel!
    
    var expandedIndexPath: IndexPath?
    var isUserWish = false
    var categories = [Category]()
    var categoryNames: [String] = []
    var selectedCategory: Category?
    var categoryId = ""
    
    
    //MARK: UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AdMobManager.checkAndUpdateBanner(self.bannerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    private func setupView(){
        
        categoryTextField.delegate = self
        categoryTextField.tintColor = UIColor.clear
        categoryTextField.textColor = UIColor.clear
        self.fetchCategories()

        AdMobManager.loadBanner(bannerView, rootViewController: self)
        self.playVideoAd()
        self.googleMapView?.delegate = self
        addTopbar()
        displayRouteDetails()
        if isUserWish{
            self.addToMyTripsButton.setTitle(deleteTitle, for: .normal)
            categoryTextField.removeFromSuperview()
        }else{
            checkMyTripp()
        }
    }
    
    private func playVideoAd(){
        if let count = AppUserDefaults.value(for: .routeDetailCount) as? Int {
            if (count + 1) % 5 == 0 {
                AdMobVideoManager.shared.presentVideoAd()
            }
            AppUserDefaults.set(value: count + 1, for: .routeDetailCount)
        }
        else{
            AppUserDefaults.set(value: 1, for: .routeDetailCount)
        }
    }
    
    private func checkMyTripp(){
        if (self.route?.isMyTrip)! {
            self.bottomConstraint.constant = 0
            self.addToMyTripsButton.isHidden = true
        }
        else{
            self.bottomConstraint.constant = 65
            self.addToMyTripsButton.isHidden = false
        }
    }
    
    private func displayRouteDetails(){
        self.timeLabel.attributedText = timeAttributedText(text: (self.route?.totalTime)!)
        self.distanceLabel.attributedText = timeAttributedText(text: (self.route?.distanceInMiles)!)
        self.roadTypeLabel.text = self.route?.roadTypeString()
        self.locationLabel.text = self.route?.savedPoints()
        self.roadLevelLabel.text = self.route?.roadLevelString()
        self.detailsLabel.text = self.route?.details
        self.curvinessLabel.text = self.route?.curvinessValue()
        self.adjustDetailsViewHight()
        self.routeNameLabel.text = self.route?.name
        self.levelImageView.image = UIImage(named: (self.route?.roadLevelIcon())!)
    }
    
    private func adjustDetailsViewHight(){
        let height = self.detailsLabel.stringHeight(withWidth: 321) + 488
        self.routeDetailsView.frame.size.height = height
    }
    
    private func timeAttributedText(text: String) -> NSAttributedString{
        let components = text.components(separatedBy: " ")
        if components.count <= 1 {
            return String.createAttributedString(text: text, font: UIFont.openSensBold(size: 24), color: UIColor.white, spacing: -0.2)
        }
        else{
            let attributedString = NSMutableAttributedString(string:text, attributes: [
                NSAttributedStringKey.font: UIFont.openSensBold(size: 12),
                NSAttributedStringKey.foregroundColor: UIColor.white,
                ])
            
            attributedString.addAttribute(NSAttributedStringKey.kern, value: -0.2, range: NSMakeRange(0, text.characters.count))
            let range = (text as NSString).range(of:components.first!)
            let attribute = [NSAttributedStringKey.font: UIFont.openSensBold(size: 24)]
            attributedString.addAttributes(attribute, range: range)
            return attributedString
        }
    }
    
    //MARK: GMSMapView Delegate Method
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        self.pushRouteDetailsFilter(route: self.route!)
    }
    
    private func addTopbar(){
        topBar = RouteDetailsTopBar.initializeTopBar()
        if let selectedRoute = self.route, selectedRoute.isMyWish == true{
            topBar?.addToWishListButton.isEnabled = false
        }
        self.topBar?.backButton.addTarget(self, action: #selector(RouteDetailsViewController.popViewController), for: .touchUpInside)
        self.topBar?.addToWishListButton.addTarget(self, action: #selector(RouteDetailsFilterViewController.wishlistButtonTapped(sender:)), for: .touchUpInside)
        self.topBar?.shareButton.addTarget(self, action: #selector(RouteDetailsFilterViewController.shareButtonTapped(sender:)), for: .touchUpInside)
        
        self.topBar?.titleLabel.text = self.route?.name
        self.topBar?.subTitleLabel.text = self.route?.stateName
        self.view.addSubview(self.topBar!)
    }
    
    //MARK: IBAction Methods
    @IBAction func closeExpandButtonTapped(_ sender: UIButton) {
        if let indexPath = self.expandedIndexPath {
            if indexPath.item != sender.tag{
                self.expandedIndexPath = nil
                self.routeDetailsTable.reloadRows(at: [indexPath], with: .fade)
                self.expandedIndexPath = IndexPath(item: sender.tag, section: 0)
                self.routeDetailsTable.reloadRows(at: [self.expandedIndexPath!], with: .fade)
            }
            else{
                self.expandedIndexPath = nil
                self.routeDetailsTable.reloadRows(at: [indexPath], with: .fade)
            }
        }
        else{
            self.expandedIndexPath = IndexPath(item: sender.tag, section: 0)
            self.routeDetailsTable.reloadRows(at: [self.expandedIndexPath!], with: .fade)
        }
        
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        self.pushRouteDetailsFilter(route: self.route!)
    }
    
    @IBAction func wishlistButtonTapped(sender : UIButton){
        self.addRouteToMyWishList()
    }
    
    @IBAction func shareButtonTapped(sender : UIButton){
        self.route?.share()
    }
    
    @IBAction func addToMyTripTapped(_ sender: Any) {
        
        if isUserWish{
            deleteFromWishList()
        }else{
            //AppLoader.showLoader()
           // addToMyTrip()
        }
    }
    func deleteFromWishList(){
        showConfirmPopup()
    }
    @objc func skipCategoryAndToMyTrip()  {
        self.categoryId = ""
        addToMyTrip()
    }
    @objc func addToMyTrip(){
        
        AppLoader.showLoader()
        self.route?.addToMyTrip(categoryId: self.categoryId, handler: { (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                self.checkMyTripp()
                self.view.layoutIfNeeded()
                AppToast.showSuccessMessage(message: message!)
                self.categoryTextField.resignFirstResponder()
            }
            else {
                AppToast.showErrorMessage(message: error!)
                 self.categoryTextField.resignFirstResponder()
            }
        })
    }
    
    private func fetchCategories(){
        AppLoader.showLoader()
        CategoryManager.sharedManager.fetchCategories { (categories, error) in
            AppLoader.hideLoader()
            if let _ = categories{
                self.categories = categories!
                self.categoryNames = self.categories.map( { $0.name })
                self.configureCategoryPicker()
            }
        }
    }
    private func configureCategoryPicker(){
        
        if categoryTextField != nil{
            
                let toolbar = UIToolbar()
                toolbar.barStyle = UIBarStyle.default
                toolbar.isTranslucent = true
                toolbar.sizeToFit()
            
                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RouteDetailsViewController.addToMyTrip))
            
                let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
            
                let cancelButton = UIBarButtonItem(title: "Skip", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RouteDetailsViewController.skipCategoryAndToMyTrip))
            
                    toolbar.setItems([cancelButton,flexibleSpace ,doneButton], animated: true)
                    toolbar.isUserInteractionEnabled = true
                categoryTextField.inputAccessoryView = toolbar
            
            categoryTextField.inputView = CustomPickerView(pickerComponent: [categoryNames], completion: { (picker, indexPath) in
                self.selectedCategory = self.categories[(indexPath?.item)!]
//                self.categoryTextField.text = self.selectedCategory!.name
                self.categoryId = (self.selectedCategory?.categoryId.description)!
                
            })

        }
        
       }
    
    
    
    // Show popup alert for delete location confirmtion
    @objc private func showConfirmPopup(){
        let bundle = Bundle(for: PopupViewController.self)
        let popupVC = PopupViewController(nibName: PopupViewController.nibName, bundle: bundle)
        popupVC.view.frame = UIScreen.main.bounds
        self.addChildViewController(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        popupVC.showConfirmPopup(withImage: UIImage(named:icLaunchBackground)!, centerImageName:icNotification, title: deleteTitle, deleteRouteFromWishMessage, yesTitle, cancel: noTitle, withDelegate: self)
        
    }
    func popupActionTapped(){
        AppLoader.showLoader()
        self.route?.removeFromWishList(handler: { (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppToast.showSuccessMessage(message: message!)
                AppNotificationCenter.post(notification: AppNotification.deleteRouteWish, withObject: ["tripWish": self.route!])
                self.popViewController()
            }
            else {
                AppToast.showErrorMessage(message: error!)
            }
        })
    }

}


extension RouteDetailsViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.hasText == false && categories.count != 0 {
            textField.text = categories[0].name
            self.categoryId = categories[0].categoryId.description
            self.selectedCategory = self.categories[0]
        }
    }
}
