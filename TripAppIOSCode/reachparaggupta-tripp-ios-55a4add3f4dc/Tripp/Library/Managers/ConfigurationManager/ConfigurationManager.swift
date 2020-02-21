//
//  ConfigurationManager.swift
//
//  Created by Arvind Singh on 07/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import GoogleMobileAds
import Firebase

final class ConfigurationManager {

    fileprivate enum AppEnvironment: String {
        case Development = "DEBUG"
        case QA = "QARELEASE"
        case Staging = "STAGING"
        case Production = "RELEASE"
    }

    fileprivate struct AppConfiguration {
        var apiEndPoint: String
        var analyticsKey: String
        var analyticsTrackingEnabled: Bool
        var environment: AppEnvironment
        var s3Bucketname: String
        var s3IdentityPoolId: String

        //MARK: Debug App Configuration
        static func debug() -> AppConfiguration {
            return AppConfiguration(apiEndPoint: "https://dev.atlasmediadev.com/api/",
                analyticsKey: "",
                analyticsTrackingEnabled: false,
                environment: .Development,
                s3Bucketname: "tripp-dev",
                s3IdentityPoolId: "us-east-1:73c8d177-e895-4ec7-a8ea-915585a17cec")
        }

        //MARK: QA App Configuration
        static func qa() -> AppConfiguration {
            return AppConfiguration(apiEndPoint: "https://qa.atlasmediadev.com/api/",
                analyticsKey: "",
                analyticsTrackingEnabled: false,
                environment: .QA,
                s3Bucketname: "tripp-qa",
                s3IdentityPoolId: "us-east-1:fe9cf226-4b64-4026-8a10-0e6a0abb933f")
        }

        //MARK: Staging App Configuration
        static func staging() -> AppConfiguration {
            return AppConfiguration(apiEndPoint: "https://staging.atlasmediadev.com/api/",
                analyticsKey: "",
                analyticsTrackingEnabled: true,
                environment: .Staging,
                s3Bucketname: "tripe-staging",
                s3IdentityPoolId: "us-east-1:1a2150f3-3f35-4614-a38b-4212a8bc4d96")
        }

        //MARK: Production App Configuration
        static func production() -> AppConfiguration {
            return AppConfiguration(apiEndPoint: "https://www.apptripp.com/api/",
                analyticsKey: "",
                analyticsTrackingEnabled: true,
                environment: .Production,
                s3Bucketname: "tripp-prod",
                s3IdentityPoolId: "us-east-1:4f743355-b433-4b5e-b91e-551116e17649")
        }
    }

    // MARK: - Singleton Instance
    class var shared: ConfigurationManager {
        struct Singleton {
            static let instance = ConfigurationManager()
        }
        return Singleton.instance
    }

    fileprivate var activeConfiguration: AppConfiguration!

    private init() {

        // Load application selected environment and its configuration
        if let environment = self.currentEnvironment() {

            self.activeConfiguration = self.configuration(environment: environment)

            if self.activeConfiguration == nil {
                assertionFailure(NSLocalizedString("Unable to load application configuration", comment: "Unable to load application configuration"))
            }
        } else {
            assertionFailure(NSLocalizedString("Unable to load application flags", comment: "Unable to load application flags"))
        }
    }

    /**
     Returns application selected build configuration/environment

     - returns: An application selected build configuration/environment
     */
    private func currentEnvironment() -> AppEnvironment? {
        #if QARELEASE
            return AppEnvironment.QA
        #elseif STAGING
            return AppEnvironment.Staging
        #elseif RELEASE
            return AppEnvironment.Production
        #else // Default configuration DEVELOPMENT
            return AppEnvironment.Production
        #endif
    }

    /**
     Returns application active configuration

     - parameter environment: An application selected environment

     - returns: An application configuration structure based on selected environment
     */
    private func configuration(environment: AppEnvironment) -> AppConfiguration {

        switch environment {
        case .Development:
            return AppConfiguration.debug()
        case .QA:
            return AppConfiguration.qa()
        case .Staging:
            return AppConfiguration.staging()
        case .Production:
            return AppConfiguration.production()
        }
    }
}

extension ConfigurationManager {

    // MARK: - Public Methods

    func applicationEnvironment() -> String {
        return self.activeConfiguration.environment.rawValue
    }

    func appBaseURL() -> String {
        return self.activeConfiguration.apiEndPoint
    }

    func analyticsKey() -> String {
        return self.activeConfiguration.analyticsKey
    }

    func analyticsTrackingEnabled() -> Bool {
        return self.activeConfiguration.analyticsTrackingEnabled
    }
    func s3Bucketname() -> String {
        return self.activeConfiguration.s3Bucketname
    }
    func s3IdentityPoolId() -> String {
        return self.activeConfiguration.s3IdentityPoolId
    }
    //MARK: - class methods
    class func googleServicesSDKKey() -> String{
        return "AIzaSyC6fte6HLbbo9dVIhnMV48HVN3ocLfqJhQ"
    }
    
    class func googleServicesAPIKey() -> String{
        return "AIzaSyBFx3N3WkRFRLKv_4Bg9GS2I2d-W4CzP5g"
    }
    
    class func setAppConfiguration(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        DatabaseHandler.setUpMigrationRealm() //xr
        UIApplication.shared.statusBarStyle = .lightContent
        AppUser.populateUserFromDatabaseIfAny()
        Global.showHomeViewIfLogin(launchOptions)
        AWSImageManager.configureAWS()
        GMSServices.provideAPIKey(googleServicesSDKKey())
        GMSPlacesClient.provideAPIKey(googleServicesSDKKey())
        AdMobManager.initializeAdMob()
        AppDelegate.tabBarFont()
        LocationFileManager.createLiveTripFolder()
        LocationManager.sharedManager.setupLocationManager()
    }
}
