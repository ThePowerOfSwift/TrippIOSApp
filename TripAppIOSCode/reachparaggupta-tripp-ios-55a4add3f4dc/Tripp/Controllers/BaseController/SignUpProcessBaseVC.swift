//
//  SignUpProcessBaseVC.swift
//  Tripp
//
//  Created by Monu on 20/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SignUpProcessBaseVC: UIViewController {

    //MARK: UIViewController life cycle mathods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: IBAction methods
    @IBAction func tapSkip(_ sender : Any){
        showConfirmPopup()
    }

    func showConfirmPopup(){
        let bundle = Bundle(for: PopupViewController.self)
        let popupVC = PopupViewController(nibName: PopupViewController.nibName, bundle: bundle)
        popupVC.view.frame = UIScreen.main.bounds
        self.addChildViewController(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        popupVC.showConfirmPopup(withImage: UIImage(named:icPopupAlertOval)!, centerImageName:icNotification, title: notification, profileSkipPopupAlert, skip, cancel: continueTitle, withDelegate: self)
    }
    
}

extension SignUpProcessBaseVC: PopupActionDelegate{
    
    func popupActionTapped() {
        self.pushToHome()
        appDelegate.scheduleNotificationForprofileComplition()
    }
}
