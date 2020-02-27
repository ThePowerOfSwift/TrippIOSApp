//
//  TripDetailsViewController.swift
//  Tripp
//
//  Created by Monu on 08/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMobileAds

class TripDetailsViewController: BaseViewController {

    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var deleteTripButton: RoundedBorderButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //-- Top bar
    @IBOutlet weak var tripDateLabel: CharacterSpaceLabel!
    @IBOutlet weak var tripNameLabel: CharacterSpaceLabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    //-- Table Header View
    @IBOutlet weak var durationLabel: CharacterSpaceLabel!
    @IBOutlet weak var distanceLabel: CharacterSpaceLabel!
    @IBOutlet weak var savedPointLabel: CharacterSpaceLabel!
    
    @IBOutlet weak var categoryLabel: CharacterSpaceLabel!
    @IBOutlet weak var tableViewBottomConstarit: NSLayoutConstraint!
    var expandedIndexPath: IndexPath?
    var groupMemberId: Int?
    var fromGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showHeaderDetails()
        AdMobManager.checkAndUpdateBanner(self.bannerView)
    }

    //MARK: Private methods / Helper
    private func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(TripDetailsViewController.updateTrip(_:)), name: AppNotification.updateTrip, object: nil)
    }
    
    @objc func updateTrip(_ notification: Notification){
        self.showHeaderDetails()
        self.detailsTableView.reloadData()
    }
    
    private func setupView(){
        AdMobManager.loadBanner(bannerView, rootViewController: self)
        self.addNotification()
        self.headerView.roundCorner([.bottomLeft, .bottomRight], radius: 12.0)
        self.editButton.characterSpace(space: 2.2)
        self.googleMapView?.delegate = self
        if fromGroup == true {
            removeDeleteButton()
            setupForGroupMemberView()
        }
        if groupMemberId != nil {
            setupForGroupMemberView()
        }
    }
    private func setupForGroupMemberView() {
        editButton.isHidden = true
        if self.route?.isMyTrip == true {
            removeDeleteButton()
        }else {
            deleteTripButton.setTitle("Add to my trip", for: .normal)
            deleteTripButton.isHidden = false
            tableViewBottomConstarit.constant = 70
        }
    }
    private func removeDeleteButton() {
        deleteTripButton.isHidden = true
        tableViewBottomConstarit.constant = 0
    }
    private func showHeaderDetails(){
        self.tripNameLabel.text = self.route?.name
        self.tripDateLabel.text = self.route?.tripDate
        self.durationLabel.attributedText = timeAttributedText(text: (self.route?.totalDuration())!)
        self.distanceLabel.attributedText = timeAttributedText(text: (self.route?.distanceInMiles)!)
        self.savedPointLabel.text = self.route?.savedPoints()
        self.route?.categoryName(handler: { categoryName in
            self.categoryLabel.text = categoryName
        })
        self.drawRouteOnMap()
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
    func addToMyTrip(){
        
        AppLoader.showLoader()
        self.route?.addToMyTrip(categoryId: "", handler: { [weak self] (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppToast.showSuccessMessage(message: message!)
                self?.removeDeleteButton()
            }
            else {
                AppToast.showErrorMessage(message: error!)
            }
        })
    }
    private func deleteTrip(){
        if deleteTripButton.titleLabel?.text == "Add to my trip" {
            addToMyTrip()
            return
        }
        
        AppLoader.showLoader()
        self.route?.deleteTrip(handler: { (message, error) in
            AppLoader.hideLoader()
            if error == nil {
                AppToast.showSuccessMessage(message: message!)
                
                self.popViewController()
            }
            else{
                AppToast.showErrorMessage(message: error!)
            }
        })
    }
    
    //MARK: IBAction methods
    @IBAction func editButtonTapped(_ sender: Any) {
        self.pushToEditWaypoint(trip: self.route!)
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        self.route?.share()
    }
    
    @IBAction func deleteTripTapped(_ sender: Any) {
        if fromGroup == true {
            addToMyTrip()
            
            return
        }
        let alert = AddRoutesAlertPopupView(cancelTripWarning, actionButtonTitle: continueTitle) { buttonIndex in
            if buttonIndex == 2{
                self.deleteTrip()
            }
        }
        alert.displayView(onView: windowGlobal != nil ? windowGlobal! : self.view)
    }
    @IBAction func moreButtonTapped(_ sender: Any) {
        
        self.pushRouteDetailsFilter(route: self.route!)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
