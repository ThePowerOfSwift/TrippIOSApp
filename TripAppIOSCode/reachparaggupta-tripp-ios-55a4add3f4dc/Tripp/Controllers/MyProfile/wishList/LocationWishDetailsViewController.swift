//
//  LocationWishDetailsViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 16/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps
import NRControls

class LocationWishDetailsViewController: BaseViewController, PopupActionDelegate {

    //MARK: IBOutlet / variables
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var location: LocationWish?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.mapView.addMapTypeToggleButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareTapped(_ sender: Any){
        self.location?.share()
    }
    @IBAction func deleteTapped(_ sender: Any) {
        showOptions()
    }
    //MARK: Private / helper
    private func showOptions() {
        var isWishOpen = true
        var buttons: [String]
        if self.location?.isCompleted == 1 {
            isWishOpen = false
            buttons = ["Delete", "Cancel"]
        } else {
            buttons = ["Mark as visited", "Delete", "Cancel"]
        }
        NRControls.sharedInstance.openActionSheetFromViewController(self, title: self.location?.name ?? "", message: "Choose an option:", buttonsTitlesArray: buttons) { [weak self] (alert, index)  in
            if isWishOpen {
                if index == 1 {
                    self?.showConfirmPopup()
                } else if index == 0 {
                    self?.completeWish()
                }
            } else {
                if index == 0 {
                    self?.showConfirmPopup()
                }
            }
            
        }
    }
    private func completeWish(){
        guard let wish = self.location else {
            return
        }
        AppLoader.showLoader()
        wish.completeWish { (message, error) in
            AppLoader.hideLoader()
            if let msg = message {
                AppToast.showSuccessMessage(message: msg)
            }else{
                AppToast.showErrorMessage(message: error ?? "Something went wrong")
            }
        }
    }
    private func setupView(){
        self.nameLabel.text = location!.name == nil ? "No name" : location!.name
        self.dateLabel.text = location!.createdAt == nil ? "" : location!.createdAt?.convertFormatOfDate(AppDateFormat.sortDate)
        self.addressLabel.text = location!.address == nil ? "" : location!.address
        addShadowAndCornerRadius()
        showMarker()
    }
    private func showMarker(){
        self.mapView.moveMapToUserlocation(CLLocation(latitude: location!.coordinate().latitude, longitude: location!.coordinate().longitude))
        let marker = GMSMarker(position: location!.coordinate())
        marker.icon = UIImage(named: icMarkerWaypoint)
        marker.map = self.mapView
    }
    private func addShadowAndCornerRadius(){
        footerView.roundCorner([.topLeft, .topRight], radius: 12)
        footerView.layer.masksToBounds = false
        footerView.layer.shadowOffset = CGSize(width: 2, height: -6)
        footerView.layer.shadowRadius = 11
        footerView.layer.shadowOpacity = 11
        footerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.21).cgColor
        
        headerView.roundCorner([.bottomLeft, .bottomRight], radius: 12)
    }
    // Show popup alert for delete location confirmtion
    private func showConfirmPopup(){
        let bundle = Bundle(for: PopupViewController.self)
        let popupVC = PopupViewController(nibName: PopupViewController.nibName, bundle: bundle)
        popupVC.view.frame = UIScreen.main.bounds
        self.addChildViewController(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        popupVC.showConfirmPopup(withImage: UIImage(named:icLaunchBackground)!, centerImageName:icNotification, title: deleteTitle, deleteLocationMessage, yesTitle, cancel: noTitle, withDelegate: self)
        
    }
    func popupActionTapped(){
        AppLoader.showLoader()
        location?.removeFromWishList(handler: { (message, error) in
            AppLoader.hideLoader()
            if let _ = error{
                AppToast.showErrorMessage(message: error!)
            }else if let _ = message {
                AppToast.showSuccessMessage(message: message!)
                self.popViewController()
            }
            
        })
    }
}
