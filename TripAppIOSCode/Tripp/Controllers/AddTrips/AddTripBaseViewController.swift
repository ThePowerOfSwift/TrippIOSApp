//
//  AddTripBaseViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 20/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AddTripBaseViewController:  UIViewController{

    weak var delegate: AddTripWalkThroughViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helpers
    func showTripAddedSuccessPopup(){
        let popup = TripAddPopup(handler: { action in
            switch action {
            case .gotoMyTrip:
                self.openMyTrip()
            case .addNewTrip:
                self.openAddNewTrip()
            case .share:
                self.shareTrip()
            }
        })
        popup.displayView(onView: self.view)
       // AdMobVideoManager.shared.presentVideoAd()
        self.perform(#selector(AddTripBaseViewController.showAdd), with: nil, afterDelay: 0.5)
    }
    @objc private func showAdd() {
        AdMobVideoManager.shared.presentVideoAd()
    }
    func openMyTrip(){
        self.dismiss(animated: true) {
            AppNotificationCenter.post(notification: AppNotification.gotoMyTrip, withObject: nil)
             AppNotificationCenter.post(notification: AppNotification.liveTripFinished, withObject: nil)
        }
    }
    func shareTrip(){
       // print("share")
        AppNotificationCenter.post(notification: AppNotification.shareMyTrip, withObject: nil)
    }
    func openAddNewTrip(){
        self.dismiss(animated: true) {
            Utils.mainQueue {
                UIApplication.topViewController()?.presentAddTripController()
                AppNotificationCenter.post(notification: AppNotification.liveTripFinished, withObject: nil)
            }
        }
    }

}
