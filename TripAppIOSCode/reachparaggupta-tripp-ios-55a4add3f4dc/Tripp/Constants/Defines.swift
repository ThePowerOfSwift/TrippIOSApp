//
//  Defines.swift
//  Tripp
//
//  Created by Monu on 13/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

//---------------- This class is used for all Define Keys in the the app ---------------------------------------

import Foundation
import UIKit

//MARK: Polyline
let polylineStrokWidth: CGFloat = 4.0

//MARK: ------------ NSNotificationCenter Constants --------------

let kRemoveProfilePhotoIdentifier = "removeProfilePhotoIdentifier"
let kPlayMovieAgain = "playMovieAgain"
let showPushNotificationPopup = "pushNotificationReceived"


//MARK: ------------ Terms&Condition and Privacy Policy URL --------------

let kTermsAndConditionsURL = "pages/terms-conditions"
let kPolicyURL = "pages/privacy-policy"

let supportEmailAddress = "reach@atlasmediadev.com"

//MARK: ------------ Depp Linking --------------------------------

let kChangePasswordDeppLinking = "trippchangepassword://tripp_php/public/password/reset/"
let googleDirectionAPIBaseURL = "https://maps.googleapis.com/maps/api/directions/json"
let googlePlaceAPIBaseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
let googleSearchPlaceAPIBaseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"

let googleMapApplicationURL = "comgooglemaps://"

let appShareUrl = "https://itunes.apple.com/us/app/tripp-find-explore-record/id1255395407?ls=1&mt=8"

//MARK: S3
let s3BaseURL = "https://s3.amazonaws.com/"
let walkthroughVideoURL = "https://s3.amazonaws.com/tripp-walkthrough/Tripp.mov"

let iTuneLink = "https://itunes.apple.com/us/app/tripp-find-explore-record/id1255395407?ls=1&mt=8"

//MARK: Privacy Polycy and Terms & Conditions
let privacyPolicyEndPoint = "privacy-policy"
let termsConditionEndPoint = "terms-condition"


//MARK: ---------- Filters Icons --------
let icGasStation = "icGasStations"
let icHotels = "icHotels"
let icCampGround = "icCampGround"
let icStatePark = "icStatePark"
let icLandMark = "icLandmark"
let icCompletedRoute = "completedRoad"
let icPopularRoute = "popularRoads"
let icRoadlevel = "roadLevel"

//MARK: --------- Route Details -------
let icStartPoint = "ic_start_point"
let icFinalPoint = "ic_end_point"
let icWayPoint = "ic_waypoint"

let icSelectedFilter = "icSelectedFilter"
let icUnSelectedFilter = "icUnSelectedFilter"

let tripPlaceholderIcon = "tripPlaceholder"

let icTripRoad = "icTripRoad"
let icTripAerial = "icTripAerial"
let icTripSea = "icTripSea"
let icRoute = "icRoute"
let icLocationWish = "locationPoint"

//MARK: --------- Place Filter ---------
let filterPark = "park"
let filterGasStation = "gas_station"
let filterCampGround = "campground"
let filterHotels = "lodging"
let filterLandMark = "locality"

let icMarkerPark = "marker_park"
let icMarkerGasStation = "marker_gasstation"
let icMarkerCampGround = "marker_campground"
let icMarkerHotels = "marker_hotels"
let icMarkerLandmark = "marker_landmark"

//MARK: -------- Trip Filter -----
let icTripFilter = "IcTripFilter"


//MARK: --------- Markers ----------------
let icMarkerWaypoint = "icWayponiMarker"
let isMarkerTripEnd = "tripEndMarker"
let marker_green_star = "marker_green_star"
let marker_green_circule = "marker_green_circule"
let marker_blue_star = "marker_blue_star"
let marker_blue_circule = "marker_blue_circule"
let marker_red_star = "marker_red_star"
let marker_red_circule = "marker_red_circule"
let marker_yellow_star = "marker_yellow_star"
let marker_yellow_circule = "marker_yellow_circule"
let icLavelEasy = "icLavelEasy"
let icLavelIntermediate = "icLavelIntermediate"
let icLavelDefficult = "icLavelDefficult"
let icLavelPro = "icLavelPro"
let starMarkerBlue = "starMarkerBlue"
let starMarkerGreen = "starMarkerGreen"
let starMarkerOrrange = "starMarkerOrrange"
let starMarkerRed = "starMarkerRed"
let starMarkerYellow = "starMarkerYellow"
let starMarkerPro = "starMarkerPro"

//MARK: -------- Common ------------------
let icSearchIcon = "searchIcon_SearchBar"
let icMapIcon = "map"
let listIconSelected = "listIconSelected"
let icMapSelected = "mapSelected"
let icListIcon = "listIcon"
let icCloseButton = "closeIcon"
let icSearchButton = "searchIcon"
let icTerrainView = "IcterrainView"
let icStandradView = "IcNormalMap"
let icAddMedia = "IcAddMedia"
let icRoadIcon = "road_icon"
let icAdvanceRoadIcon = "advancedRoad"
let icTopRoadIcon = "topRoad"

//MARK: popup alert
let icPopupAlertOval = "ic_popupalert_oval"
let icNotification = "ic_Notification"
let icLaunchBackground = "launchBackground"
let icSuccess = "ic_Success"

//MARK: Tutorial
let icTutorialRoutes = "tutorialRoutes"
let icTutorialAddTrip = "tutorialAddTrip"

//MARK: settings
let icSettingProfile = "ic_setting_profile"
let icSettingLegal = "ic_setting_legal"
let icSettingOther = "ic_setting_other"

let shareAppLogo = "shareAppLogo"

struct AppDateFormat {
    static let UTCShort = "yyyy-MM-dd"
    static let UTCFormat = "yyyy-MM-dd HH:mm:ss"
    static let sortDate = "MM/dd/yy"
    static let UTCUniversalFormat = "yyyy-MM-dd HH:mm:ss z"
    static let fileNameFormat = "yyyyMMddHHmmss"
}

struct LinkTapEvent {
    static let signupEvent = "signupevent"
    static let forgotPasswordEvent = "forgotpasswordevent"
    static let signinEvent = "signinevent"
    static let termsAndConditionEvent = "termsandconditionevent"
    static let privacyPolicyEvent = "privacypolicyevent"
    static let clearFilterEvent = "event:clearfilter"
    static let gotoSettingEvent = "gotoSettingEvent"
}

struct TripModString {
    static let road = "Road"
    static let aerial = "Aerial"
    static let sea = "Sea"
    static let live = "Live trips"
}
