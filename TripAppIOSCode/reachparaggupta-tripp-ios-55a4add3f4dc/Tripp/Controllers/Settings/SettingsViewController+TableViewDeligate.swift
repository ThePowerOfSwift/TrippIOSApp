//
//  SettingsViewController+TableViewDeligate.swift
//  Tripp
//
//  Created by Monu on 23/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return settins.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cellData = settins[indexPath.row]
        switch cellData.cellType {
        case .Header:
            return 70
            
        case .Menu:
            return 55.5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cellData = settins[indexPath.row]
        
        switch cellData.cellType {
        case .Header:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: SettingHeaderCell.identifier, for: indexPath) as! SettingHeaderCell
            headerCell.nameLabel.text = cellData.name
            headerCell.logo.image = UIImage(named: cellData.logo)
            return headerCell
            
        case .Menu:
            let menuCell = tableView.dequeueReusableCell(withIdentifier: SettingMenuCell.identifier, for: indexPath) as! SettingMenuCell
            menuCell.nameLabel.text = cellData.name
            return menuCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cellData = settins[indexPath.row]
        if cellData.cellType == .Menu {
            switch cellData.name {
            case SettingMenuName.changePassword:
                self.pushChangePassword()
                
            case SettingMenuName.updateMyEmail:
                self.pushVerifyPassword()
                
            case SettingMenuName.TermsAndCondition:
                self.pushAppWebView(type: .termsAndConditions)
                
            case SettingMenuName.privacyPolicy:
                self.pushAppWebView(type: .privacyPolicy)
                
            case SettingMenuName.contactUs:
                self.openMailComposer()
                
            case SettingMenuName.giveYourFeedBack:
                self.pushFeedback()
            
            case SettingMenuName.gettingStarted:
                self.pushTutorial()
                
            case SettingMenuName.walkthrough:
                playWalkthrough()
            case SettingMenuName.notifications:
                self.fetchNotifications()
            case SettingMenuName.myProfile:
                self.pushToProfile()
            case SettingMenuName.subscription:
                self.presentSubscriptionController()
                
            default:
                break
            }
        }
    }
    //MARK: - Play video
    func playWalkthrough() {
        VideoManager.playVideoWithUrl(viewController: self, url: walkthroughVideoURL)
    }
    
}

enum SettingCellType {
    case Header
    case Menu
}

struct SettingMenuName {
    static let changePassword = "Change password"
    static let updateMyEmail = "Update my email"
    static let subscription = "Subscription"
    static let myProfile = "My Profile"
    static let TermsAndCondition = "T&Cs"
    static let privacyPolicy = "Privacy policy"
    static let contactUs = "Contact us"
    static let gettingStarted = "Getting started (Tutorial)"
    static let giveYourFeedBack = "Give us your feedback"
    static let profileSettingsHeader = "Profile Settings"
    static let legalSettingsHeader = "Legal"
    static let otherSettingsHeader = "Others"
    static let walkthrough = "Walkthrough Video"
    static let notifications = "Notifications"
}

