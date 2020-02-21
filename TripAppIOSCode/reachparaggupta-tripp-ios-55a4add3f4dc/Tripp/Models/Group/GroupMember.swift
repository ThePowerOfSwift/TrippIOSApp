//
//  GroupMember.swift
//  Tripp
//
//  Created by Bharat Lal on 12/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import RealmSwift
enum GroupRole: Int {
    case admin = 1
    case member
    var stringValue: String {
        switch self {
        case .admin:
            return "Group Admin"
        case .member:
            return "Member"
        }
    }
}
enum MemberStatus: Int {
    case invited = 1
    case accepted
    case rejected
    
    var stringValue: String {
        switch self {
        case .invited:
            return "Invited"
        case .accepted:
            return ""
        case .rejected:
            return "Rejected"
        }
    }
}

class GroupMember: Object {
    let groupId = RealmOptional<Int>()
    @objc dynamic var email = ""
    @objc dynamic var role = 0 // 1=> admin, 2=> member
    @objc dynamic var status = 0 //1=>invited, 2=>accepted, 3=>rejected
    let groupUserId = RealmOptional<Int>()
    @objc dynamic var profileImage: String?
    @objc dynamic var fullName: String?
}
