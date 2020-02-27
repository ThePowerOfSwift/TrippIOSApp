//
//  SettingsViewController.swift
//  Tripp
//
//  Created by Monu on 23/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import MessageUI
import NRControls
import GoogleMobileAds

class SettingsViewController: UIViewController {
    
    var settins : [(cellType:SettingCellType, name:String, logo:String)] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AdMobManager.checkAndUpdateBanner(self.bannerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBaction methods
    @IBAction func logoutButtonTapped(_ sender: Any) {
        showConfirmPopup()
    }

    //MARK: Private methods

    private func setupView(){
        self.populateAllMenus()
        AdMobManager.loadBanner(self.bannerView, rootViewController: self)
    }
    
    private func populateAllMenus(){
        settins.removeAll()
        //-- Populate all menu and header
        settins.append((cellType: .Header, name: SettingMenuName.profileSettingsHeader, logo: icSettingProfile))
        settins.append((cellType: .Menu, name: SettingMenuName.myProfile, logo: ""))
        settins.append((cellType: .Menu, name: SettingMenuName.changePassword, logo: ""))
        settins.append((cellType: .Menu, name: SettingMenuName.updateMyEmail, logo: ""))
        settins.append((cellType: .Menu, name: SettingMenuName.subscription, logo: ""))
        
        settins.append((cellType: .Header, name: SettingMenuName.legalSettingsHeader, logo: icSettingLegal))
        settins.append((cellType: .Menu, name: SettingMenuName.TermsAndCondition, logo: ""))
        settins.append((cellType: .Menu, name: SettingMenuName.privacyPolicy, logo: ""))
        
        settins.append((cellType: .Header, name: SettingMenuName.otherSettingsHeader, logo: icSettingOther))
        settins.append((cellType: .Menu, name: SettingMenuName.notifications, logo: ""))
        settins.append((cellType: .Menu, name: SettingMenuName.contactUs, logo: ""))
        settins.append((cellType: .Menu, name: SettingMenuName.gettingStarted, logo: ""))
        settins.append((cellType: .Menu, name: SettingMenuName.giveYourFeedBack, logo: ""))
        settins.append((cellType: .Menu, name: SettingMenuName.walkthrough, logo: ""))
        
    }
    
    // Show popup alert for logout
    public func showConfirmPopup(){
        let bundle = Bundle(for: PopupViewController.self)
        let popupVC = PopupViewController(nibName: PopupViewController.nibName, bundle: bundle)
        popupVC.view.frame = UIScreen.main.bounds
        self.addChildViewController(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        popupVC.showConfirmPopup(withImage: UIImage(named:icLaunchBackground)!, centerImageName:icNotification, title:logoutTitle, logoutMessage, yesTitle, cancel: noTitle, withDelegate: self)
        
    }

    public func openMailComposer(){
        if !MFMailComposeViewController.canSendMail() {
            AppToast.showErrorMessage(message: mailNotConfiured)
            return
        }
        let userInfo = self.userInfo()
        let name = userInfo.userName.isEmpty ? "" : "Name: \(userInfo.userName),</br>"
        let message = "</br></br></br>\(name)UserId: \(userInfo.userId),</br>Device: \(userInfo.iPhoneModel),</br>OS Version: \(userInfo.osVersion)"
        
        NRControls.sharedInstance.openMailComposerInViewController([supportEmailAddress], viewcontroller: self, message: message) { (mailComposeReslut, error) in
            
            switch mailComposeReslut{
            case .sent:
                AppToast.showSuccessMessage(message: mailSuccessMessage)
            case.failed:
                AppToast.showErrorMessage(message: mailNotConfiured)
            default:
                break
            }
            
        }
    }
    private func userInfo() -> (userName: String, userId: Int, iPhoneModel: String, osVersion: String){
        let user = AppUser.currentUser()
        return (userName: user.fullName, userId: user.userId, iPhoneModel: Devices.deviceName(), osVersion: Devices.deviceOSVersion)
    }
    func fetchNotifications() {
        AppLoader.showLoader()
        APIDataSource.fetchNotifications { (notifications, error) in
            AppLoader.hideLoader()
            if let message = error {
                AppToast.showErrorMessage(message: message)
            } else if let notis = notifications, notis.count != 0 {
                self.pushToNotificationsList(notis)
                
            } else {
                AppToast.showSuccessMessage(message: "No Notification found for you!")
            }
        }
    }
    
    
}

extension SettingsViewController: PopupActionDelegate{
    
    func popupActionTapped() {
        AppLoader.showLoader()
        APIDataSource.logout { (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppUser.deleteUser()
                Global.setOnboardingRootVC()
                Global.alreadyAddedRoutes.removeAll()
            }
            else {
                AppToast.showErrorMessage(message: error!)
            }
        }
    }
}
