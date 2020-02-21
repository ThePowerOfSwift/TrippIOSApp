//
//  Route+MapView.swift
//  Tripp
//
//  Created by Bharat Lal on 10/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import NRControls

extension HomeViewController: GMSMapViewDelegate{
    
    // user tapped on marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let routeMarker = marker as? RouteMarker{
            showPopupFor(routeMarker.route)
            return true
        }
        if let wishMarker = marker as? LocationWishMarker {
            locationWishTapped(wishMarker.locationWish)
            return true
        }
        if let placeMarker = marker as? PlaceWishMarker {
            placeWishTapped(placeMarker)
            return true
        }
        return false
    }
    // user tapped on polyline
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if let tappedOverlay = overlay as? RoutePolyline {
            showPopupFor(tappedOverlay.route)
        }
        //let routePolyline = overlay as! RoutePolyline
        
    }
    private func placeWishTapped(_ marker: PlaceWishMarker) {
        var isWishOpen = true
        guard let wish = marker.placeWish else {
            return
        }
        var buttons: [String]
        wish.isAddedToWishlist = 1
        if wish.isMarkedAsComplete == 1 {
            isWishOpen = false
            buttons = ["View Details", "Cancel"]
        } else {
            buttons = ["Mark as visited", "View Details", "Cancel"]
        }
        NRControls.sharedInstance.openActionSheetFromViewController(self, title: wish.name, message: "Choose an option:", buttonsTitlesArray: buttons) { [weak self] (alert, index)  in
            if isWishOpen {
                if index == 1 {
                    self?.pushPlacesDetails(wish)
                } else if index == 0 {
                    self?.completePlaceWish(marker)
                }
            }else {
                if index == 0 {
                   self?.pushPlacesDetails(wish)
                }
            }
            
        }
    }
    private func locationWishTapped(_ locationWish: LocationWish) {
        var isWishOpen = true
        var buttons: [String]
        if locationWish.isCompleted == 1 {
            isWishOpen = false
            buttons = ["View Details", "Cancel"]
        } else {
            buttons = ["Mark as visited", "View Details", "Cancel"]
        }
        NRControls.sharedInstance.openActionSheetFromViewController(self, title: locationWish.name ?? "", message: "Choose an option:", buttonsTitlesArray: buttons) { [weak self] (alert, index)  in
            if isWishOpen {
                if index == 1 {
                    self?.pushToLocationdetails(locationWish)
                } else if index == 0 {
                    self?.completeLocationWish(locationWish)
                }
            }else {
                if index == 0 {
                    self?.pushToLocationdetails(locationWish)
                }
            }
            
        }
    }
    private func showPopupFor(_ route: Route){
        let detailPopup = RouteDetailPopupView(route, handler: { action in
            switch action {
            case .viewMore:
                if (self.parent as? RoutesBaseViewController)?.topView?.selectedTab == .Routes{
                    self.pushRouteDetails(route: route)
                }else if route.tripMode == TripMode.Live.rawValue{
                    if (self.parent as? MyTripsViewController)?.groupMember == nil {
                        self.presentLiveTripController(route)
                    } else {
                        self.presentLiveTripController(route, fromGroups: true)
                    }
                    
                }else{
                    if route.isMyWish {
                        self.loadWishDetails(route.tripId)
                    }else {
                        if (self.parent as? MyTripsViewController)?.groupMember == nil {
                            self.pushTripDetails(withRoute: route)
                        } else {
                            self.pushTripDetails(withRoute: route, groupMemberId: (self.parent as? MyTripsViewController)?.groupMember?.groupUserId.value, fromGroup: false)
                        }
            
                    }
                }
            case .addToWishlist:
                if route.isMyTrip == false {
                    self.addRouteToMyWish(route: route)
                } else {
                     AppToast.showErrorMessage(message: "You have already completed this route.")
                }
            case .share:
                route.share()
            }
        })
        
        self.configurePopup(detailPopup: detailPopup)
        detailPopup.displayView(onView: self.view)
    }
    private func loadWishDetails(_ tripId: Int) {
        AppLoader.showLoader()
        APIDataSource.tripDetails(service: .fetchTripDetail(tripId: tripId)) { (route, error) in
            AppLoader.hideLoader()
            if let trip = route{
                self.pushRouteDetails(route: trip, isUserWish: true)
            }else{
                AppToast.showErrorMessage(message: error!)
            }
        }
    }
    private func configurePopup(detailPopup:RouteDetailPopupView){
        if (self.parent as? RoutesBaseViewController)?.topView?.selectedTab == .MyTrips{
            detailPopup.roadLabel.isHidden = true
            detailPopup.roadTypeLabel.isHidden = true
            detailPopup.routeLevelImageIcon.isHidden = true
            detailPopup.addToMyTripButton.isHidden = true
        }
        else{
            detailPopup.roadLabel.isHidden = false
            detailPopup.roadTypeLabel.isHidden = false
            detailPopup.routeLevelImageIcon.isHidden = false
            detailPopup.addToMyTripButton.isHidden = false
        }
    }
    
    // user start moving map
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        routesmanager?.cancelAllOperations()
        routesmanager = nil
    }
    // map view stoped draging
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let cameraPosition = position.target
        self.myLocation = CLLocation(latitude: cameraPosition.latitude, longitude: cameraPosition.longitude)
        if let parentVC = self.parent as? RoutesBaseViewController, parentVC.topView?.selectedTab == .Routes{
            self.restartRouteFetching()
        }
    }
    
    //MARK: helper
    func restartRouteFetching(){
       // self.routeCounter = 0
        self.fetchAndDrawRoutes(myLocation!)
    }
    func addRouteToMyWish(route: Route){
        AppLoader.showLoader()
        route.addToMyWish(handler: { (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppToast.showSuccessMessage(message: message!)
            }
            else {
                AppToast.showErrorMessage(message: error!)
            }
        })
    }
    private func completeLocationWish(_ wish: LocationWish){
        AppLoader.showLoader()
        wish.completeWish { (message, error) in
            AppLoader.hideLoader()
            if let msg = message {
                AppToast.showSuccessMessage(message: msg)
            }else{
                AppToast.showErrorMessage(message: error ?? "Something went wrong")
            }
        }
    }
    private func completePlaceWish(_ marker: PlaceWishMarker){
        guard let wish = marker.placeWish else {
            return
        }
        AppLoader.showLoader()
        APIDataSource.markPlaceAsComplete(service: .markPlaceAsCompleted(placeId: wish.placeId)) { (message, error) in
            AppLoader.hideLoader()
            if let msg = message {
                AppToast.showSuccessMessage(message: msg)
                wish.isMarkedAsComplete = 1
                marker.icon = UIImage(named: starMarkerGreen)
            }else{
                AppToast.showErrorMessage(message: error ?? "Something went wrong")
            }
        }
    }
    /**
     * @method fetchAndDrawRoutes
     * @discussion fetch And Draw Routes on the map
     */
    func fetchAndDrawRoutes(_ location: CLLocation){
        let lat = String(location.coordinate.latitude)
        let lon = String(location.coordinate.longitude)
        
        fetchAndDrawRoutes(lat: lat, lon: lon)
        
    }
    func fetchAndDrawRoutes(lat: String, lon: String){
        if let manager = self.routesmanager{
            manager.cancelAllOperations()
        }
        self.routesmanager = nil
        self.routesmanager = RoutesManager()
        self.routesmanager?.startFetchingRoutes(lat, lon,filter: self.filters, { (route, error) in
            guard let aRoute = route else{
                return
            }
            if Global.alreadyAddedRoutes.contains(aRoute.tripId) == false{
                Global.alreadyAddedRoutes.append(aRoute.tripId)
                Utils.mainQueue {
                    self.routeCounter += 1
                    self.updateRouteCounterInfo()
                    self.drawRoute(route: aRoute)
                }
            }
       })
    }
    func fetchRoutesInState(_ state: State){
        let location = CLLocation(latitude: Double(state.lat!)!, longitude: Double(state.lon!)!)
        self.mapView.moveMapToUserlocation(location)
        self.filters = ""
        self.cleanMapView()
        self.fetchAndDrawRoutes(lat: state.lat!, lon: state.lon!)
    }
    /**
     * @method applyFilter
     * @discussion fetch And Draw Routes on the map with filter
     */

    func applyFilter(){
        self.cleanMapView()
        self.fetchAndDrawRoutes(self.myLocation!)
    }
    func cleanMapView(){
        self.routesmanager?.cancelAllOperations()
        Global.alreadyAddedRoutes.removeAll()
        self.routeCounter = 0
        self.updateRouteCounterInfo()
        self.routesmanager = nil
        routes.removeAll()
        self.mapView.clear()
    }
    /**
     * @method clearFilters
     * @discussion fetch And Draw Routes on the map with no filter
     */
    func clearFilters(){
        self.filters = ""
        self.isFilterApplied = false
        routes.removeAll()
        self.applyFilter()
    }

    func focusMapToShowAllMarkers(){
        let bounds = self.markers.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate($1.position)
        }
        self.mapView.animate(with: .fit(bounds, withPadding: 30))
        
    }
}
