//
//  AppNavigations.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func popToRootViewController() {
        _ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func popViewController() {
        if let _ = navigationController{
             _ = self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
       
    }
    
    func checkAndPushSignIn(){
        var found = false
        if let controllres = self.navigationController?.viewControllers{
            for controller in controllres{
                if controller.isKind(of: SigninViewController.self){
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    found = true
                    break
                }
            }
        }
        if !found{
            let signinVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.login.rawValue)
            self.navigationController?.pushViewController(signinVC, animated: true)
        }
    }
    
    func checkAndPushSignUp(){
        var found = false
        if let controllres = self.navigationController?.viewControllers{
            for controller in controllres{
                if controller.isKind(of: SignupViewController.self){
                    _ = self.navigationController?.popToViewController(controller, animated: true)
                    found = true
                    break
                }
            }
        }
        if !found{
            let signupVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.signUp.rawValue)
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
    //MARK: - Push To View Controller
    
    func pushLogin(){
        let loginVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.login.rawValue) as! SigninViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func pushForgotPassword(){
        let forgotPasswordVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.forgotPassword.rawValue) as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func pushToHome(){
//        let tabBarVC = homeStoryBoard().instantiateInitialViewController()
//        self.present(tabBarVC!, animated: true, completion: nil)
        Global.showHomeViewIfLogin(nil)
    }
    
    func pushAppWebView(type:webViewType, presentView: Bool = false){
        let appWebViewVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.appWebView.rawValue) as! AppWebViewController
        appWebViewVC.type = type
        if presentView == true {
            self.present(appWebViewVC, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(appWebViewVC, animated: true)
        }
    }
    
    //MARK: - Sign up Flow
    
    func pushSignUp(){
        let signUpVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.signUp.rawValue) as! SignupViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    func pushSignUpSuccess(email:String){
        let signUpSuccessVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.signUpSuccess.rawValue) as! SignUpSuccessViewController
        signUpSuccessVC.profile.email = email
        self.navigationController?.pushViewController(signUpSuccessVC, animated: true)
    }
    
    func pushSignUpFullName(profile: Profile){
        let signUpFullNameVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.signUpFullName.rawValue) as! SignUpFullNameViewController
        signUpFullNameVC.profile = profile
        self.navigationController?.pushViewController(signUpFullNameVC, animated: true)
    }
    
    func checkAndPushResetPassword(){
        if !Global.resetPasswordToken.isEmpty {
            let resetPasswordVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.resetPassword.rawValue) as! ResetPasswordViewController
            resetPasswordVC.token = Global.resetPasswordToken
            self.navigationController?.pushViewController(resetPasswordVC, animated: false)
        }
        Global.resetPasswordToken = ""
    }
    
    func pushAddProfilePhotoWith(profile: Profile){
        let addProfilePhotoVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.signUpAddProfilePhoto.rawValue) as! SignUpAddPhotoViewController
        addProfilePhotoVC.profile = profile
        self.navigationController?.pushViewController(addProfilePhotoVC, animated: true)
    }
    
    func pushEditProfilePhotoWith(profile: Profile){
        let editProfilePhotoVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.signUpEditProfilePhoto.rawValue) as! SignUpEditPhotoViewController
        editProfilePhotoVC.profile = profile
        self.navigationController?.pushViewController(editProfilePhotoVC, animated: true)
    }
    
    func pushAddVehical(profile: Profile){
        let addVehicleVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.signUpAddVehicle.rawValue) as! SignUpAddVehicalViewController
        addVehicleVC.profile = profile
        addVehicleVC.isEditMode = false
        self.navigationController?.pushViewController(addVehicleVC, animated: true)
    }
    func presentAddVehical(profile: Profile){
        let addVehicleVC = loginStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.signUpAddVehicle.rawValue) as! SignUpAddVehicalViewController
        addVehicleVC.profile = profile
        addVehicleVC.isEditMode = true
        self.present(addVehicleVC, animated: true, completion: nil)
    }
    func pushChangePassword(){
        let changePasswordVC = settingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.changePassword.rawValue) as! ChangePasswordViewController
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    func pushVerifyPassword(){
        let verifyPasswordVC = settingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.verifyPassword.rawValue) as! VerifyPasswordViewController
        self.navigationController?.pushViewController(verifyPasswordVC, animated: true)
    }
    
    func pushUpdateEmail(){
        let updateEmailVC = settingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.updateEmail.rawValue) as! UpdateEmailViewController
        self.navigationController?.pushViewController(updateEmailVC, animated: true)
    }
    
    func pushOnBoarding(){
        let onboardingVC = onboardingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.onboarding.rawValue) as! WalkthroughVC
        self.navigationController?.pushViewController(onboardingVC, animated: true)
    }
    
    func pushFeedback(){
        let feedbackVC = settingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.feedback.rawValue) as! FeedbackViewController
        self.navigationController?.pushViewController(feedbackVC, animated: true)
    }
    
    func pushTutorial(){
        let tutorialVC = tutorialStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.tutorial.rawValue) as! TutorialWalkThroughVC
        self.navigationController?.pushViewController(tutorialVC, animated: true)
    }
    func pushToProfile(_ groupMember: GroupMember? = nil){
        let vc = profileStoryBoard().instantiateInitialViewController() as! MyProfileViewController
        vc.groupMember = groupMember
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushRouteDetails(route: Route, isUserWish: Bool = false){
        let routeDetailsVC = routeDetailsStoryBoard().instantiateInitialViewController() as! RouteDetailsViewController
        routeDetailsVC.route = route
        routeDetailsVC.isUserWish = isUserWish
        self.navigationController?.pushViewController(routeDetailsVC, animated: true)
    }
    
    func pushRouteDetailsFilter(route: Route){
        let filterVC = routeDetailsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.routeDetailsFilter.rawValue) as! RouteDetailsFilterViewController
        filterVC.route = route
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
    func presentAddTripController(){
        let walkThroughVC = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.addtripWalkThrough.rawValue)
        let nav = UINavigationController(rootViewController: walkThroughVC)
      //  nav.modalPresentationStyle = .overCurrentContext
        //self.tabBarController?.present(nav, animated: true, completion: nil)
        self.present(nav, animated: true, completion: nil)
    }
    func presentSubscriptionController(){
        AppLoader.showLoader()
        InAppManager.sharedManger.fetchProducts { (status, error) in
            AppLoader.hideLoader()
            if status {
                if let subscriptionController = inAppStoryBoard().instantiateInitialViewController() {
                    self.tabBarController?.present(subscriptionController, animated: true, completion: nil)
                }
            } else {
                AppToast.showErrorMessage(message: (error?.localizedDescription) ?? "")
            }
        }
    }
    func presentCreateGroupController(_ groupToEdit: Group? = nil){
        let walkThroughVC = groupsStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.createGroup.rawValue) as! CreateGroupWalkthroughViewController
        if let group = groupToEdit {
            walkThroughVC.group = group
        }
        let nav = UINavigationController(rootViewController: walkThroughVC)
       // nav.modalPresentationStyle = .overCurrentContext
        
        present(nav, animated: true, completion: nil)
    }
    func pushToAddWaypoint(walkThrough: AddTripWalkThroughViewController?){
        let addWayPointVC = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.addWaypoint.rawValue) as! AddWaypointToTripViewController
        addWayPointVC.trip = walkThrough?.trip
        walkThrough?.navigationController?.pushViewController(addWayPointVC, animated: true)
    }
    func pushToAddLiveTrip(walkThrough: AddTripWalkThroughViewController?){
        let addLiveTripVC = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.addliveTripVC.rawValue) as! AddLiveTripViewController
        addLiveTripVC.trip = walkThrough?.trip
        walkThrough?.navigationController?.pushViewController(addLiveTripVC, animated: true)
    }
    func presentLiveTripController(_ trip: Route? = nil, fromGroups: Bool = false){
        let addLiveTripVC = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.addliveTripVC.rawValue) as! AddLiveTripViewController
        let nav = UINavigationController(rootViewController: addLiveTripVC)
        nav.modalPresentationStyle = .overCurrentContext
        nav.isNavigationBarHidden = true
        if trip != nil{
            addLiveTripVC.trip = trip?.copy() as? Route
            addLiveTripVC.originalTrip = trip
            addLiveTripVC.isEditMode = true
        }else{
            addLiveTripVC.isEditMode = false
        }
        addLiveTripVC.fromGroups = fromGroups
        self.tabBarController?.present(nav, animated: true, completion: nil)
    }
    func pushToEditWaypoint(trip: Route){
        let addWayPointVC = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.addWaypoint.rawValue) as! AddWaypointToTripViewController
        addWayPointVC.trip = trip.copy() as? Route
        addWayPointVC.originalTrip = trip
        addWayPointVC.isEditMode = true
        let nav = UINavigationController(rootViewController: addWayPointVC)
        nav.modalPresentationStyle = .overCurrentContext
        nav.isNavigationBarHidden = true
        self.tabBarController?.present(nav, animated: true, completion: nil)
    }
    func pushGroupDetails(_ group: Group){
        let tripDetails = groupsStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.groupDetails.rawValue) as? GroupDetailsViewController
        tripDetails?.group = group
        self.navigationController?.pushViewController(tripDetails!, animated: true) //GroupMembersViewController
    }
    func pushToGroupMembers(_ group: Group){
        let vc = groupsStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.groupMembers.rawValue) as? GroupMembersViewController
        vc?.group = group
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func presentAddMorePeople(_ group: Group) {
        let vc = groupsStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.createGroupInvite.rawValue) as! CreateGroupInvitePeopleViewController
        vc.group = group
        present(vc, animated: true, completion: nil)
    }
    func pushToShareTrip(_ tripId: Int, originGroup: Group) {
        let vc = groupsStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.shareTripInGroup.rawValue) as? ShareTripWithGroupsViewController
        vc?.tripId = tripId
        vc?.originGroup = originGroup
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func showMemberTripView(_ member: GroupMember) {
        let vc  = myTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.myTrips.rawValue) as! MyTripsViewController
        vc.groupMember = member
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushTripDetails(withRoute: Route, groupMemberId: Int? = nil, fromGroup: Bool = false){
        let tripDetails = tripDetailsStoryBoard().instantiateInitialViewController() as? TripDetailsViewController
        tripDetails?.route = withRoute
        tripDetails?.groupMemberId = groupMemberId
        tripDetails?.fromGroup = fromGroup
        self.navigationController?.pushViewController(tripDetails!, animated: true)
    }
    func presentWishList(){
        let wishListController = profileStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.wishList.rawValue)
        let nav = UINavigationController(rootViewController: wishListController)
        nav.modalPresentationStyle = .overCurrentContext
        nav.isNavigationBarHidden = true
        self.tabBarController?.present(nav, animated: true, completion: nil)
        
    }
    func pushToAddLocationWishController(){
        let addLocationController = profileStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.addLocationWishVC.rawValue) as? AddLocationViewController
        addLocationController?.delegate = (self as! AddLocationDelegate)
        self.navigationController?.pushViewController(addLocationController!, animated: true)
    }
    func pushToLocationdetails(_ location: LocationWish){
        
        let locationDetailsVC = profileStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.locationWishDetails.rawValue) as? LocationWishDetailsViewController
        locationDetailsVC?.location = location
        self.navigationController?.pushViewController(locationDetailsVC!, animated: true)
        
    }
    func pushToShareTrip(_ image: UIImage, _ trip: Route){
        let vc = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.shareTrip.rawValue) as! ShareTripViewController
        vc.tripImage = image
        vc.trip = trip
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func pushToNotificationsList(_ notification: [UserNotification]){
        let vc = settingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.notifications.rawValue) as! NotificationsViewController
        vc.notifications = notification
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func pushPlacesList(_ category: PlaceCategory){
        let placesVC = categoriesStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.placesList.rawValue) as? PlacesViewController
        placesVC?.category = category
        self.navigationController?.pushViewController(placesVC!, animated: true) 
    }
    func pushPlacesDetails(_ place: Place){
        let placesVC = categoriesStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.placeDetailsView.rawValue) as? PlaceDetailsViewController
        placesVC?.place = place
        self.navigationController?.pushViewController(placesVC!, animated: true)
    }
    func presentCategoryIAPWith(_ category: PlaceCategory){
        AppLoader.showLoader()
        InAppManager.sharedManger.fetchProducts { (status, error) in
            AppLoader.hideLoader()
            if status {
                let iapVC = inAppStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.categoryIAP.rawValue) as! CategoryIAPViewController
                iapVC.category = category
                iapVC.delegate = self as? CategoryPurchaseProtocol
                let nav = UINavigationController(rootViewController: iapVC)
                nav.modalPresentationStyle = .overCurrentContext
                self.tabBarController?.present(nav, animated: true, completion: nil)
            } else {
                AppToast.showErrorMessage(message: (error?.localizedDescription) ?? "")
            }
        }
    }
    
}
