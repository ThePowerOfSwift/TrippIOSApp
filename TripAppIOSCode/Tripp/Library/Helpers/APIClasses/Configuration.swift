//
//  Configuration.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleMobileAds
import Firebase

class Configuration {

    class func appBaseURL() -> String {

        #if DEBUG
            return "https://dev.atlasmediadev.com/api/" // DEV URL

        #endif

        #if QARELEASE
            return "https://qa.atlasmediadev.com/api/" // QA URL
            
        #endif
        
        #if STAGING
            return "https://staging.atlasmediadev.com/api/" //Staging
            
        #endif

        #if RELEASE
            return "https://www.atlasmediadev.com/api/" // PRODUCTION URL

        #endif

    }

    class func s3Bucketname() -> String {
        
        #if DEBUG
            return "tripp-dev" // DEV
            
        #endif
        
        #if QARELEASE
            return "tripp-qa"// QA
            
        #endif
        
        #if STAGING
            return "tripe-staging" //Staging
            
        #endif
        
        #if RELEASE
            return "tripp-prod" //Production
            
        #endif
        
        
    }
    class func s3IdentityPoolId() -> String {
        
        #if DEBUG
            return "us-east-1:73c8d177-e895-4ec7-a8ea-915585a17cec" // DEV
            
        #endif
        
        #if QARELEASE
            return "us-east-1:fe9cf226-4b64-4026-8a10-0e6a0abb933f"// QA
            
        #endif
        
        #if STAGING
            return "us-east-1:1a2150f3-3f35-4614-a38b-4212a8bc4d96" //Staging
            
        #endif
        
        #if RELEASE
            return "us-east-1:4f743355-b433-4b5e-b91e-551116e17649" //Production
            
        #endif
        
    }
    
    class func googleServicesSDKKey() -> String{
       return "AIzaSyC6fte6HLbbo9dVIhnMV48HVN3ocLfqJhQ"
    }
    
    class func googleServicesAPIKey() -> String{
        return "AIzaSyBFx3N3WkRFRLKv_4Bg9GS2I2d-W4CzP5g"
    }
        
    class func setAppConfiguration() {
        FirebaseApp.configure()
        IQKeyboardManager.sharedManager().enable = true
        DatabaseHandler.setUpMigrationRealm()
        UIApplication.shared.statusBarStyle = .lightContent
        AppUser.populateUserFromDatabaseIfAny()
        Global.showHomeViewIfLogin()
        AWSImageManager.configureAWS()
        GMSServices.provideAPIKey(googleServicesSDKKey())
        GMSPlacesClient.provideAPIKey(googleServicesSDKKey())
        AdMobManager.initialize()
        AppDelegate.tabBarFont()
        LocationFileManager.createLiveTripFolder()
        LocationManager.sharedManager.setupLocationManager()
    }
    
    
}
