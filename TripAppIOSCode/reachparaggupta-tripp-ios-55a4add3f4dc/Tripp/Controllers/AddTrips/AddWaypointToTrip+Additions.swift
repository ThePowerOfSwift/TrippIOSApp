//
//  AddWaypointToTrip+Additions.swift
//  Tripp
//
//  Created by Bharat Lal on 10/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// Tool tip
extension AddWaypointToTripViewController{
    func popTipOberver(_ notification: NSNotification){
        if let popType = notification.userInfo?[notificationPopTypeKey] as? PopTipType {
            
            switch popType {
            case .viewSavedPoints:
                showTip(popType: .finishRoute)
            default:
                break
            }
        }
    }
    func showFirstTip(){
        showTip(popType: .addWaypoint)
    }
     func showTip(popType: PopTipType){
        if isEditMode {
            return
        }
        guard let isToolTipShown = AppUserDefaults.value(for: .tripTips) else {
            showToolTip(popType: popType)
            return
        }
        guard let shown = isToolTipShown as? Bool, shown == true else {
            showToolTip(popType: popType)
            return
        }
    }
    @objc func checkAndShowCardTip(){
        if isEditMode {
            return
        }
        guard let isToolTipShown = AppUserDefaults.value(for: .tripWaypoitTip) else {
            showCardTip()
            return
        }
        guard let shown = isToolTipShown as? Bool, shown == true else {
            showCardTip()
            return
        }
    }
    func showCardTip(){
        if self.tripWaypointVC.waypoints.count > 0 {
            var frame = self.tripWaypointVC.waypointTableView.frame
            frame.origin.y = frame.origin.y + 75 + 108 + 59
            PopTipManager.showWayPointCardTip(inView: self.view, from: frame)
        }
    }
    private func showToolTip(popType: PopTipType){
            switch popType {
            case .addWaypoint:
                PopTipManager.showTipWith(popType: .addWaypoint, inView: self.view, from: CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0))
            case .savePoint:
                var frame = self.tripWaypointVC.savePointButton.frame
                frame.origin.y = frame.origin.y + self.tripWaypointVC.view.frame.origin.y - 25
                PopTipManager.showTipWith(popType: .savePoint, inView: self.view, from: frame)
            case .waypointSearch:
                let searchButton = self.topBar.searchButton
                 PopTipManager.showTipWith(popType: .waypointSearch, inView: self.view, from: searchButton!.frame)
            case .viewSavedPoints:
                PopTipManager.showTipWith(popType: .viewSavedPoints, inView: self.view, from: self.tripWaypointVC.view.frame)
            case .finishRoute:
                var frame = self.tripWaypointVC.savePointButton.frame
                frame.origin.y = frame.origin.y + self.tripWaypointVC.view.frame.origin.y - 25
                PopTipManager.showTipWith(popType: .finishRoute, inView: self.view, from: frame)
            default:
                break
            }
        
    }
}
extension AddWaypointToTripViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchViewController.view.isHidden = true
        topBar.searchField.resignFirstResponder()
    }
    func textFieldDidChange(_ textField: UITextField){
        searchViewController.view.isHidden = textField.isEmpty()
        if !textField.isEmpty(){
            searchViewController.searchForPlace(textField.text!, callback:{ place in
                //add place on mapView
                self.addressFromGeocodeCoordinate(coordinate: place.coordinate)
                if self.topBar.searchField.isEmpty() == false{
                    self.topBar.searchButtonTapped(nil)
                }
                self.topBar.searchField.text = ""
                let waypointsCount = self.trip!.waypoints.count
                if waypointsCount == 0 || waypointsCount == 1 {
                    self.mapView.moveMapToUserlocation(CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                } else if waypointsCount <= 25 {
                    if let startLocation = self.trip?.waypoints.first?.location(), let endLocation = self.trip?.waypoints.last?.location() {
                        
                        self.mapView.setCameraPositionFor(location1: startLocation, location2: endLocation)
                    }
                }
            })
        }
    }
}

extension AddWaypointToTripViewController: TripWaypointDelegate{
    //-- Move or delete waypoints
    
    func deleteWaypoint(atIndex: Int) {
        self.clearLastDroppedMarker()
        //-- Remove object from trip
        if tripWaypointVC.waypoints.count <= 0 {
            self.trip?.waypoints.removeAll()
        }
        else{
            self.trip?.waypoints.remove(at: atIndex)
        }
        
        self.displayWaypointAndRoutes()
    }
    
    func moveWaypoint(from: Int, to: Int) {
        self.clearLastDroppedMarker()
        let moveWayPoint = self.trip?.waypoints[from]
        self.trip?.waypoints.remove(at: from)
        self.trip?.waypoints.insert(moveWayPoint!, at: to)
        self.displayWaypointAndRoutes()
    }
    
    private func clearLastDroppedMarker(){
        if let _ = self.currentDropMarker {
            self.trip?.waypoints.removeLast()
        }
        self.clearCurrentMarker()
    }
}
// MARK: - completed trips
extension AddWaypointToTripViewController {
    func fetchAndDrawMyTrips(){
        tripManager = TripsManager()
        tripManager?.startFetchingTripps(drivingMode: nil, isLive: nil, categoryId: trip?.categoryId.value?.description,{ [weak self] (route, error) in
            guard let aRoute = route else{
                return
            }
            
            let search = self?.completedRoutes.filter({$0.tripId == route?.tripId}) ?? [Route]()
            if search.count <= 0{
                Utils.mainQueue {
                    self?.completedRoutes.append(aRoute)
                    self?.mapView.drawRoute(route: aRoute)
                }
            }
            
        })
    }
}
