//
//  AppUser.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

enum Subscription {
    case free
    case subscribed
    case expire
}

class AppUser: Object {

    //User parameters
    @objc dynamic var userId = 0
    @objc dynamic var fullName = ""
    @objc dynamic var email = ""
    @objc dynamic var profileImage = ""
    @objc dynamic var role = 0
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
    @objc dynamic var isComplete = false
    @objc dynamic var isFirstLogin = false
    @objc dynamic var userToken = ""
    @objc dynamic var isBlocked = false
    @objc dynamic var isNotify = false
    @objc dynamic var deviceId = ""
    
    @objc dynamic var vehicle:Vehicle?
    
    @objc dynamic var statesTraveled = 0
    @objc dynamic var countriesTraveled = 0
    @objc dynamic var easyRouteTraveled = 0
    @objc dynamic var intermediateRouteTraveled = 0
    @objc dynamic var difficultRouteTraveled = 0
    @objc dynamic var proRouteTraveled = 0
    @objc dynamic var roadMilesTraveled: Double = 0
    @objc dynamic var aerialMilesTraveled: Double = 0
    @objc dynamic var seaMilesTraveled: Double = 0
    @objc dynamic var wishlistCount = 0
    @objc dynamic var membershipExpiry: String?

    
    // category statictics
    var categoryStats = List<CategoryStat>()

    static var sharedInstance: AppUser? = AppUser() //Shared instance

    //populate current user from database user
    fileprivate func populateCurrentUser() {
        AppUser.currentUser().userId = self.userId
        AppUser.currentUser().fullName = self.fullName
        AppUser.currentUser().email = self.email
        AppUser.currentUser().profileImage = self.profileImage
        AppUser.currentUser().role = self.role
        AppUser.currentUser().latitude = self.latitude
        AppUser.currentUser().longitude = self.longitude
        AppUser.currentUser().isComplete = self.isComplete
        AppUser.currentUser().isFirstLogin = self.isFirstLogin
        AppUser.currentUser().userToken = self.userToken
        AppUser.currentUser().isBlocked = self.isBlocked
        AppUser.currentUser().isNotify = self.isNotify
        AppUser.currentUser().deviceId = self.deviceId
        AppUser.currentUser().vehicle = self.vehicle
        AppUser.currentUser().statesTraveled = self.statesTraveled
        AppUser.currentUser().wishlistCount = self.wishlistCount
        AppUser.currentUser().countriesTraveled = self.countriesTraveled
        AppUser.currentUser().easyRouteTraveled = self.easyRouteTraveled
        AppUser.currentUser().intermediateRouteTraveled = self.intermediateRouteTraveled
        AppUser.currentUser().difficultRouteTraveled = self.difficultRouteTraveled
        AppUser.currentUser().proRouteTraveled = self.proRouteTraveled
        AppUser.currentUser().roadMilesTraveled = self.roadMilesTraveled
        AppUser.currentUser().aerialMilesTraveled = self.aerialMilesTraveled
        AppUser.currentUser().seaMilesTraveled = self.seaMilesTraveled
        AppUser.currentUser().membershipExpiry = self.membershipExpiry
    }

    // update clone in a database as realm need write block to do this
    func clone() -> AppUser {
        let tempUser = AppUser()
        tempUser.userId = self.userId
        tempUser.fullName = self.fullName
        tempUser.email = self.email
        tempUser.profileImage = self.profileImage
        tempUser.role = self.role
        tempUser.latitude = self.latitude
        tempUser.longitude = self.longitude
        tempUser.isFirstLogin = self.isFirstLogin
        tempUser.userToken = self.userToken
        tempUser.isBlocked = self.isBlocked
        tempUser.isNotify = self.isNotify
        tempUser.deviceId = self.deviceId
        tempUser.isComplete = self.isComplete
        tempUser.vehicle = self.vehicle
        tempUser.statesTraveled = self.statesTraveled
        tempUser.wishlistCount = self.wishlistCount
        tempUser.countriesTraveled = self.countriesTraveled
        tempUser.easyRouteTraveled = self.easyRouteTraveled
        tempUser.intermediateRouteTraveled = self.intermediateRouteTraveled
        tempUser.difficultRouteTraveled = self.difficultRouteTraveled
        tempUser.proRouteTraveled = self.proRouteTraveled
        tempUser.roadMilesTraveled = self.roadMilesTraveled
        tempUser.aerialMilesTraveled = self.aerialMilesTraveled
        tempUser.seaMilesTraveled = self.seaMilesTraveled
        tempUser.membershipExpiry = self.membershipExpiry
        return tempUser
    }

    func updateUser(user:AppUser){
        self.fullName = user.fullName
        self.email = user.email
        self.profileImage = user.profileImage
        self.role = user.role
        self.latitude = user.latitude
        self.longitude = user.longitude
        self.isFirstLogin = user.isFirstLogin
        self.isBlocked = user.isBlocked
        self.isNotify = user.isNotify
        self.vehicle = user.vehicle
        self.isComplete = user.isComplete
        self.statesTraveled = user.statesTraveled
        self.wishlistCount = user.wishlistCount
        self.countriesTraveled = user.countriesTraveled
        self.easyRouteTraveled = user.easyRouteTraveled
        self.intermediateRouteTraveled = user.intermediateRouteTraveled
        self.difficultRouteTraveled = user.difficultRouteTraveled
        self.proRouteTraveled = user.proRouteTraveled
        self.roadMilesTraveled = user.roadMilesTraveled
        self.aerialMilesTraveled = user.aerialMilesTraveled
        self.seaMilesTraveled = user.seaMilesTraveled
        self.membershipExpiry = user.membershipExpiry
        
        self.populateCurrentUser()
        self.saveUpdateUser()
    }
    
    func cloneFromUser(_ user: AppUser){
        self.fullName = user.fullName
        self.email = user.email
        self.profileImage = user.profileImage
        self.role = user.role
        self.latitude = user.latitude
        self.longitude = user.longitude
        self.isFirstLogin = user.isFirstLogin
        self.isBlocked = user.isBlocked
        self.isNotify = user.isNotify
        self.vehicle = user.vehicle
        self.isComplete = user.isComplete
        self.statesTraveled = user.statesTraveled
        self.wishlistCount = user.wishlistCount
        self.countriesTraveled = user.countriesTraveled
        self.easyRouteTraveled = user.easyRouteTraveled
        self.intermediateRouteTraveled = user.intermediateRouteTraveled
        self.difficultRouteTraveled = user.difficultRouteTraveled
        self.proRouteTraveled = user.proRouteTraveled
        self.roadMilesTraveled = user.roadMilesTraveled
        self.aerialMilesTraveled = user.aerialMilesTraveled
        self.seaMilesTraveled = user.seaMilesTraveled
        self.membershipExpiry = user.membershipExpiry
    }
    
    func subscription() -> Subscription {
        guard let userId = UserDefaults.standard.value(forKey: InAppManager.Keys.userId) as? Int, userId == AppUser.sharedInstance?.userId else {
            return .free
        }
        
        if let expiryDate = UserDefaults.standard.value(forKey: "expires_date") as? String {
            let dateOriginalFormat = DateFormatter()
            dateOriginalFormat.dateFormat = AppDateFormat.UTCUniversalFormat
            if let subscriptionDate = dateOriginalFormat.date(from: expiryDate), subscriptionDate > Date() {
                return .subscribed
            } else {
                return .expire
            }
        } else {
            return .free
        }
    }
    
    //current user
    class func currentUser() -> AppUser {
        //fetch user if already exists and check wether autoupdate worls or not
        return AppUser.sharedInstance!
    }

    //check if user saved in database and assign to current user
    class func populateUserFromDatabaseIfAny() {
        do{
            let results = try Realm().objects(AppUser.self)
            if results.count > 0 {
                let user = results.last!
                user.populateCurrentUser()
                
                
                // if realm array object > 0 
                
                // call api upload to AWS -> Callback - Delete from realm
            }
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
    }

    class func destroy() {

        AppUser.sharedInstance = nil
        AppUser.sharedInstance = AppUser()
        AppUser.sharedInstance?.userId = 0

    }
    //check if user is login
    class func isLoginUser() -> Bool {
        
        if AppUser.currentUser().userId != 0 {
            return true
        }
        return false
    }


    //update user when edit user details
    func saveUpdateUser() {
        self.populateCurrentUser()
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(self.clone(), update: true)
                
            })
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
        

    }


    override static func primaryKey() -> String? {
        return "userId"
    }

   // Specify properties to ignore (Realm won't persist these)
    override static func ignoredProperties() -> [String] {

        return [""]
    }

    //isSameUser
    func isSameUser(_ user: Object) -> Bool {
        if self == user {
            return true
        }
        return false
    }

    //Array Of Users
    class func usersArray(_ resultArray: [AnyObject]) -> [AppUser] {
        let finalArray = resultArray.map() {
            AppUser(value: $0)
        }
        return finalArray
    }

    //delete user
    class func deleteUser() {
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
            realm.deleteAll()

            })
            self.destroy()
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }

    }

}
