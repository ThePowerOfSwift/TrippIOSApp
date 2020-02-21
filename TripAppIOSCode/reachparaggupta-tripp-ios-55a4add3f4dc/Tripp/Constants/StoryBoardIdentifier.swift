//
//  StoryBoardIdentifier.swift
//  Tripp
//
//  Created by Monu on 13/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

//---------------- This class is used for all StoryBoards Identifers (SB)  in the the app ---------------------------------------

import Foundation
import UIKit

//Name should start with SB for Storyboard identifier
enum StoryboardNames: String {
    
    case login = "Login"
    case onboarding = "Onboarding"
    case home = "Home"
    case routes = "Routes"
    case profile = "MyProfile"
    case setting = "Settings"
    case tutorial = "Tutorial"
    case tripDetails = "TripDetails"
    case routeDetails = "RouteDetails"
    case mediaViewer = "MediaViewer"
    case addtrips = "AddTrips"
    case myTrips = "MyTrips"
    case groups = "Groups"
    case inApp = "InApp"
    case categories = "Categories"
}

// ------------------------------- View Controller Identifier -----------------------
enum StoryboardViewControllerIdentifier: String {
    
    case login = "SigninViewController"
    case forgotPassword = "ForgotPasswordViewController"
    case signUp = "SignupViewController"
    case home = "HomeViewController"
    case routeList = "RouteListViewController"
    case appWebView = "AppWebViewController"
    case resetPassword = "ResetPasswordViewController"
    case signUpSuccess = "SignUpSuccessViewController"
    case tabBarController = "TabBarViewController"
    case signUpAddProfilePhoto = "SignUpAddPhotoViewController"
    case signUpEditProfilePhoto = "SignUpEditPhotoViewController"
    case signUpAddVehicle = "SignUpAddVehicalViewController"
    case signUpFullName = "SignUpFullNameViewController"
    case myProfile = "MyProfileViewController"
    case wishList = "WishListViewController"
    case changePassword = "ChangePasswordViewController"
    case verifyPassword = "VerifyPasswordViewController"
    case updateEmail = "UpdateEmailViewController"
    case feedback = "FeedbackViewController"
    case onboarding = "WalkthroughVC"
    case tutorial = "TutorialWalkThroughVC"
    case tutorialRoutes = "TutorialRoutesViewController"
    case tutorialFilter = "TutorialRoutesFilterVC"
    case tutorialSavePoint = "TutorialSavePointVC"
    case tutorialAddTripp = "TutorialAddTrippViewControllerVC"
    case tutorialSaveOtherPoint = "TutorialSaveOtherPointVC"
    case tutorialSearch = "TutorialSearchVC"
    case tutorialFinished = "TutorialEndFinishVC"
    case routeDetailsFilter = "RouteDetailsFilterViewController"
    case addTripName = "AddTripNameViewController"
    case selectTriptype = "SelectTripTypeViewController"
    case selectTripMode = "SelectTripModeViewController"
    case addtripWalkThrough = "AddTripWalkThroughViewController"
    case addWaypoint = "AddWaypointToTripViewController"
    case addTripWaypoiint = "TripWaypointViewController"
    case sarchViewController = "SearchViewController"
    case onboardingFirstVC = "OnboardingFirstVC"
    case onboardingSecondVC = "OnboardingSecondVC"
    case onboardingThirdVC = "OnboardingThirdVC"
    case onboardingFourthVC = "OnboardingFourthVC"
    case onboardingFifthVC = "OnboardingFifthVC"
    case tripDetails = "TripDetailsViewController"
    case addLocationWishVC = "AddLocationViewController"
    case locationWishDetails = "LocationWishDetailsViewController"
    case addliveTripVC = "AddLiveTripViewController"
    case liveTripMediaVC = "LiveTripMediaViewController"
    case shareTrip = "ShareTripViewController"
    case notifications = "NotificationsViewController"
    case createGroup = "CreateGroupWalkthroughViewController"
    case createGroupName = "CreateGroupNameViewController"
    case createGroupImage = "CreateGroupImageViewController"
    case createGroupInvite = "CreateGroupInvitePeopleViewController"
    case groupDetails = "GroupDetailsViewController"
    case groupMembers = "GroupMembersViewController"
    case groupList = "GroupListViewController"
    case myTrips = "MyTripsViewController"
    case shareTripInGroup = "ShareTripWithGroupsViewController"
    case placesList = "PlacesViewController"
    case placesListView = "PlaceListViewController"
    case placesMapView = "PlaceMapViewController"
    case placeDetailsView = "PlaceDetailsViewController"
    case categoryIAP = "CategoryIAPViewController"

}

// ------------------- Nib Identifiers ---------------
enum NibIdentifier: String {
    case filterView = "FilterViewCell"
    case routeFilterView = "RoadTypeFilterCollectionViewCell"
    case filterHeader = "FilterHeaderReusableView"
}


//MARK: ------------------------------ Get App StoryBoards  ----------------------------
//-- Access login storyboard
func loginStoryBoard() -> UIStoryboard {
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.login.rawValue, bundle: nil)
    return storyboard
}

func onboardingStoryBoard() -> UIStoryboard {
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.onboarding.rawValue, bundle: nil)
    return storyboard
}

func homeStoryBoard() -> UIStoryboard {
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.home.rawValue, bundle: nil)
    return storyboard
}
func profileStoryBoard() -> UIStoryboard {
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.profile.rawValue, bundle: nil)
    return storyboard
}

func settingStoryBoard() -> UIStoryboard {
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.setting.rawValue, bundle: nil)
    return storyboard
}

func tutorialStoryBoard() -> UIStoryboard {
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.tutorial.rawValue, bundle: nil)
    return storyboard
}

func tripDetailsStoryBoard() -> UIStoryboard {
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.tripDetails.rawValue, bundle: nil)
    return storyboard
}

func routeDetailsStoryBoard() -> UIStoryboard {
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.routeDetails.rawValue, bundle: nil)
    return storyboard
}

func routesStoryBoard() -> UIStoryboard{
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.routes.rawValue, bundle: nil)
    return storyboard
}

func mediaViewerStoryBoard() -> UIStoryboard{
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.mediaViewer.rawValue, bundle: nil)
    return storyboard
}
func addTripsStoryBoard() -> UIStoryboard{
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.addtrips.rawValue, bundle: nil)
    return storyboard
}
func inAppStoryBoard() -> UIStoryboard{
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.inApp.rawValue, bundle: nil)
    return storyboard
}
func myTripsStoryBoard() -> UIStoryboard{
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.myTrips.rawValue, bundle: nil)
    return storyboard
}
func groupsStroryBoard() -> UIStoryboard{
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.groups.rawValue, bundle: nil)
    return storyboard
}
func categoriesStroryBoard() -> UIStoryboard{
    let storyboard: UIStoryboard = UIStoryboard(name: StoryboardNames.categories.rawValue, bundle: nil)
    return storyboard
}
