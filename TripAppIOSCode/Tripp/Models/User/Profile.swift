//
//  Profile.swift
//  Tripp
//
//  Created by Monu on 22/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class Profile: NSObject {

    var email = ""
    var fullName = ""
    
    var vehicleType = ""
    var vehicleMake = ""
    var vehicleModel = ""
    var vehicleYear = ""
    var isCompleted = false
    
    var image:UIImage?
    
    class func createProfileFromUserWithImage(_ image: UIImage) -> Profile{
        let profile = Profile()
        let user = AppUser.currentUser()
        profile.isCompleted = user.isComplete
        if let bike = user.vehicle{
            fillVehicleInProfile(profile, withUserVehicle: bike)
        }
        
        if user.isComplete == false{
            return profile
        }else{
            profile.email = user.email
            profile.fullName = user.fullName
            profile.image = image
            return profile
        }
    }
    class func fillVehicleInProfile(_ profile: Profile, withUserVehicle vehicle: Vehicle){
        profile.vehicleType = vehicle.type
        profile.vehicleMake = vehicle.make
        profile.vehicleModel = vehicle.model
        profile.vehicleYear = vehicle.manufacturingYear
    }
    
}
