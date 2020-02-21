//
//  Group.swift
//  Tripp
//
//  Created by Bharat Lal on 12/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
import RealmSwift

class Group: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var userId = 0 // craeted by
    @objc dynamic var groupId = 0
    @objc dynamic var image: String?
    @objc dynamic var role = 0 // 1=> admin, 2=> member
    @objc dynamic var email = ""
    @objc dynamic var totalMembers = 0
    @objc dynamic var totalTrips = 0
    @objc dynamic var status = 0 //1=>invited, 2=>accepted, 3=>rejected
    @objc dynamic var admin: AppUser?
    @objc dynamic var isSelected = false
}

extension Group {

    func updateMembership(_ status: MemberStatus, _ completionHandler: @escaping (_ message: String?, _ error: String?)-> Void) {
        APIDataSource.toggleLike(service: .upadteGroupMemnerStatus(groupId: groupId, status: status.rawValue)) { [weak self] (message, error) in
            if error == nil {
                self?.status = status.rawValue
            }
            
            completionHandler(message, error)
        }
    }
    func removeMember(_ memberId: String, _ completionHandler: @escaping (_ message: String?, _ error: String?)-> Void) {
        APIDataSource.commonUpdateService(service: .removeMember(groupId: groupId, memberEmailId: memberId)) { [weak self] (message, error) in
            if error == nil {
              self?.updateGroupMemberCount()
            }
            completionHandler(message, error)
        }
       // APIDataSource.commonUpdateService(service: .removeMember(groupId: groupId, memberEmailId: memberId), handler: completionHandler)
    }
    func shareTripWithGroup(_ tripId: Int, _ completionHandler: @escaping (_ message: String?, _ error: String?)-> Void) {
        APIDataSource.commonUpdateService(service: .shareTripWithGroup(groupId: groupId, tripId: tripId), handler: completionHandler)
    }
    func updateGroupMemberCount(_ add: Bool = false) {
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                if add == true {
                    self.totalMembers += 1
                }else {
                 self.totalMembers -= 1
                }
                
            })
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
    }
    func updateGroupNameAndImageUrl(_ group: Group) {
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                self.name = group.name
                self.image = group.image
            })
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
    }
}
