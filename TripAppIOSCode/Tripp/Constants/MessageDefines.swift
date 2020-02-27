//
//  MessageDefines.swift
//  Tripp
//
//  Created by Monu on 13/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

//---------------- This class is used for Message Defines  in the the app ---------------------------------------


import Foundation

//MARK: -----------App General-------------------
let appTitle = "Tripp"
let profileNotification = "Kindly complete your profile, it will help us to know you more."
let profileNotificationIdentifier = "profileNotification"
let notYetRegistered = "Not registered yet? Please, Sign up"
let registerdUserSignIn = "Registered? Please, Sign in"
let signIn = "Sign in"
let signUp = "Sign up"
let forgotPassword = "Forgot password?"
let cancel = "Cancel"
let shareApp = "Share"
let facebookShare = "Share on Facebook"
let shareOnOther = "Share on other platforms"
let settings = "Settings"
let okayButtonTitle = "OK"
let someErrorMessage = "Some error"
let skip = "Skip"
let yesTitle = "Yes"
let noTitle = "No"
let succesTitle = "Success"
let logoutTitle = "Logout"
let notification = "Notification"
let waypointTitle = "Waypoint"

//MARK: -----------------------Error Messages-----------------------------
let alreadyHaveAccount = "Already have an account? Log in"
let dontHaveAccount = "Don’t have an account? Sign up"
let termsAndConditionsAndPrivacypolicy = "By clicking \"Sign up\" you agree to \nour Terms and Conditions and Privacy policy"
let inAppTerms = "By tapping \"Subscribe\", you are agree to our Terms and Conditions and Privacy policy."
let termsAndConditions = "Terms and Conditions"
let privacyPolicy = "Privacy policy"
let resetPassword = "The link to reset password will reach to your registered email."
let mailSuccessMessage = "Mail has been sent to admin successfully!"
let tutorialFinished = "Tutorial finished."
let internetConectionError = "Please check your internet connection & try again."
let toastTitle = ""
let emailEmptyMessage = "Email ID can not be blank, please enter a valid Email ID."
let emailValidationMessage = "Please enter a valid email address."
let passwordValidationMessage = "Password must contain minimum 6 characters to maximum 12 characters."
let passwordEmptyValidation = "Password field can not be blank, please enter a password."
let fullNameEmptyValidation = "Full name field cannot be blank, please enter your full name."
let fullNameValidation = "Only alphanumeric characters are allowed in full name"
let newPasswordEmptyValidation = "Please enter new password."
let newPasswordValidationMessage = "New password must contain minimum 6 characters to maximum 12 characters."
let currentPasswordValidationMessage = "Current password must contain minimum 6 characters to maximum 12 characters."
let currentPasswordValidation = "Please enter your current password."
let confirmPasswordEmptyValidation = "Please enter confirm new password."
let confirmPasswordValidation = "New password and Confirm new password does not match."
let logoutMessage = "Are you sure you want to logout?"
let failedToUploadImageOnSS3 = "Failed to upload image on server. Please try again."
let vehicleTypeEmptyMessage = "Please enter vehicle type"
let vehicleMakeEmptyMessage = "Please enter vehicle make"
let vehicleModelEmptyMessage = "Please enter vehicle model"
let vehicleYearEmptyMessage = "Please enter vehicle year"
let vehicleTypeAlphanumericMessage = "Only alphanumeric characters are allowed in vehicle type"
let vehicleMakeAlphanumericMessage = "Only alphanumeric characters are allowed in vehicle make"
let vehicleModelAlphanumericMessage = "Only alphanumeric characters are allowed in vehicle model"
let emailUpdate = "Your email has been updated successfully."

//MARK: Alerts
let profileSkipPopupAlert = "Filling all details will make your profile looks amazing. Make sure you finish it."
let tryAgainMessage = "Something went wrong, please try again."
let noRecordFound = "No Record found!"
let noInternetConnection = "No internet connection available, please check your connection and try again."
let noLocationFound = "No Location found!"
let underDevelopmentMessage = "Functionality is under development!"
let mailNotConfiured = "Unable to send email. Please check your email settings and try again."

//MARK: MyProfile
let loadingWishList = "loading your wish list."
let noData = "No record found."
let numberOfRecords = "routes saved."
let numberOfPoints = "ponits saved."
let numberOfPlaces = "places saved."
let titleWishList = "Wish list"
let titleMyprofile = "My profile"
let profileImageUpdated = "Profile photo has been updated successfully"
let nameUpdated = "Your name has been updated successfully"
let vehicleUpdated = "Your vehicle has been updated successfully"
let selectPhotoMessage =  "Happy with your photo?\n"
let tapNextMessage = "Please, tap “Next” to continue"
let profileCompleteMessage = "You have created your profile."

//MARK: Unauthorized access
let unauthorizedAccessMessage = "Your account is being used in some other device. Please login again to use the app."

//MARK: Feedback
let feedbackSentMessage = "Feedback sent successfully."
let goToSettingMessage = "Go to settings"
let feedbackCommentPlaceholder = "Your comment...."
let feedbackEmaptyValidation = "Please enter your comment."

//MARK: Tutorials
let tutorialTitleRoute = "Routes"
let tutorialTitleAddTrip = "Add trips"
let tutorialRouteTitle = "Tap on any marked routes to get detailed information"
let tutorialRouteTitleBoldText = "marked routes"
let tutorialRouteSubTitle = "Use the Search to find a specific state or route name"
let tutorialSpecificState = "specific state"
let tutorialRouteName = "route name"
let tutorialFilterTitle = "Tap the filter button to select the type of route of preference"
let tutorialTheFilter = "the filter"
let tutorialAddTripTitle = "Tap and hold on any location on the map to create multiple points"
let tutorialCreateMultiplePoint = "create multiple points"
let tutorialSavePointTitle = "Tap save point button to start saving your point locations"
let tutorialSavePoint = "save point"
let tutorialSaveOthetPointTitle = "Slide the card up to see your saved points"
let tutorialSearchTitle = "Also use the search option to find and create multiple Points"
let tutorialSearchOption = "search option"
let tutorialEntTitle = "Use the finish route button to complete your route"
let tutorialFinisRoute = "finish route"
let showVideoTitle = "We have uploaded a video to help you to navigate all the features of the app.  You can access this video from the Settings as well. \n Do you want to play the video before start exploring the App?"
let showVideo = "Play"
let saveOfflineWhenNoInternet = "No Internet. No problem you will find the saved trip once your phone is connected to the internet connection."



//MARK: ---------Onboarding---------------------
let onBoardingFirstTitle = "Create"
let onBoardingFirstSubTitle = " your own trips"
let onBoardingSecondTitle = "Discover"
let onBoardingSecondSubTitle = "amazing routes"
let onBoardingThirdTitle = "Share"
let onBoardingThirdSubTitle = "with friends"
let onBoardingFourthTitle = "Save"
let onBoardingFourthSubTitle = "important details"
let onBoardingFifthTitle = "Live"
let onBoardingFifthSubTitle = "the magic"

//MARK: ----------- Routes -------
let locationAccessDenied = "You have not given permission to access current location. To enable go to device settings and change the location prmission"
let locationAccessDeniedAlways = "You have not given permission to access your always fetch location. To enable go to device settings and change the location prmission"
let permissionNotFoundMessage = "You have not given permission to access your fetch location."
let routeCountMessage = " routes found close to you"
let routeCountWithFilterMessage = " routes found Clear filters"
let clearFilters = "Clear filters"
let fetchingRoutes = "Fetching routes near you..."
let tripCountMessage = "trips created"
let noCategory = "No category"
let chooseOption = "Choose any option"
let editCategory = "Edit category"
let deleteCategory = "Delete category"
let deleteTitle = "Delete"



//MARK: ---------- Filters ---------
let gasStationFilter = "Gas stations"
let hotelsFilter = "Hotels"
let campGroundFilter = "Camp ground"
let stateParkFilter = "State parks"
let landMarkFilter = "Land mark"
let completedRoutes = "Completed routes"
let popularRoutes = "Popular routes"
let proRoad = "Advanced road"
let difficultRoad = "Difficult road"
let intermediateRoad = "Intermediate road"
let easyRoad = "Easy road"

//MARK: Route Details
let buttonCloseView = "Close view"
let buttonExpandView = "Expand view"
let startingPointMessage = "Starting Point"
let finalPointMessage = "Final Point"
let waypointMessage = "Way point"

//MARK: create group
let groupNameMessage =  "Please enter group name."

//MARK: Add trip
let saveTripMessge = "By stoping this trip you will no longer be able to record your progress."
let saveTripQuestion = "Are you sure you want to stop it?"
let cancelTripWarning = "By removing this trip, you will lose all the information created."
let cancelLocationWishWarning = "By removing this point, you will lose all the information created."
let addTripNameMessage =  "Please enter trip name."
let addLocationNameMessage = "Please enter location name."
let addTripDateMessage = "Please enter trip date."
let removeTitle = "Remove"
let closeTitle = "Stop"
let continueTitle = "Continue"
let invalidLocation = "Invalid position"
let maxPlaceslimitMessage = "You can add max 25 waypoints including start and end points"
let removeWaypointWarning = "By removing this card from the trip, your stats might get affected."

let initialWaypointMessage = "Tap and hold on any location on the map or use the search to create your Starting Point."
let addNextWaypointMessage = "Location saved. Please tap and hold or use the search bar to add your next stop."
let addMoreWaypoints = "Location saved. Please add another point or finish your route."
let openAddMediaAlertTitle = "Choose your media preference"
let addMediaAlertMessage = "(The length of the video should be maximum\nof length 30 seconds)"
let waypointTitleMessage = "Starting point:"

let roadRouteNotFoundMessage = "Route not found with these locations"
let unableToFindAddress = "Unable to find address"
let deleteMediaMessage = "Are you sure you want to delete this media?"
let deleteRouteFromWishMessage = "Are you sure you want to delete this route from wish list?"
let deleteLocationMessage = "Are you sure you want to delete this point?"

//MARK: UIImagePicker Controller
let unauthorizedAccessImagePickerMessage = "You do not have permissions enabled for this."
let changeSettingMessage = "Would you like to change them in settings?"
let takeANewPhotoMessage = "Take a New Photo"
let takeANewVideoMessage = "Take a New Video"
let pickFromPhotoLibraryMessage = "Pick from Photo Library"
let photoUploadValidationMessage = "You can upload upto 10 photos in a waypoint."
let videoUploadValodationMessage = "You can upload upto 3 videos in a waypoint."
let videoLengthValidationMessage = "Maximum video length allowed upto 30 seconds."

//MARK: PopUp tips
let routeMainPopupTitle = "We've color coded the routes so it's easy for you to understand"
let routeMainPopupTitleBold = "routes of preference"
