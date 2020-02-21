//
//  ShareTripViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 17/01/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class ShareTripViewController: UIViewController, IGCMenuDelegate {
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    var tripImage: UIImage?
    var trip: Route?
    var igcMenu: IGCMenu?
    var isOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tripImageView.image = tripImage
        setupMenu()
        // Do any additional setup after loading the view.
    }
    func setupMenu(){
        //Grid menu setup
        igcMenu = IGCMenu()
        igcMenu?.menuButton = self.menuButton   //Grid menu setup
        igcMenu?.menuSuperView = self.view      //Pass reference of menu button super view
        igcMenu?.disableBackground = true       //Enable/disable menu background
        igcMenu?.numberOfMenuItem = 3           //Number of menu items to display
        //Menu background. It can be BlurEffectExtraLight,BlurEffectLight,BlurEffectDark,Dark or None
        igcMenu?.backgroundType = .BlurEffectDark
   
        igcMenu?.menuItemsNameArray = ["My Trips", "Add New Trip", "Share"]
        
        igcMenu?.menuImagesNameArray = ["mapSelected.png", "icAddANewTrip.png", "shareArrow.png"]

        igcMenu?.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func menuTapped(_ sender: UIButton) {
        if isOpen == true {
            igcMenu?.hideCircularMenu()
        } else {
            igcMenu?.showCircularMenu()
        }
        isOpen = !isOpen
    }
    func share() {
        if let screenshot = tripImage {
            ShareManager.shareAppActionSheet(onController: self, handler: { (isCancel, isFacebook) in
                if !isCancel {
                    if isFacebook {
                        Utils.shareImageOnFacebook(screenshot, type: .bike, trip: self.trip!, controller: self)
                    } else {
                        self.trip?.share(screenshot, shouldShareUrl: false)
                    }
                }
            })
        }
        
    }
     func gotoMytrip() {
        self.dismiss(animated: true) {
            AppNotificationCenter.post(notification: AppNotification.gotoMyTrip, withObject: nil)
            AppNotificationCenter.post(notification: AppNotification.liveTripFinished, withObject: nil)
        }
    }
     func addTrip() {
        self.dismiss(animated: true) {
            Utils.mainQueue {
                UIApplication.topViewController()?.presentAddTripController()
                AppNotificationCenter.post(notification: AppNotification.liveTripFinished, withObject: nil)
            }
        }
    }
    
    func igcMenuSelected(selectedMenuName: String, atIndex index: Int) {
        //Perform any action on selection of menu item
        if index == 0 {
            gotoMytrip()
        } else if index == 1 {
            addTrip()
        } else{
            share()
        }
    }

}
