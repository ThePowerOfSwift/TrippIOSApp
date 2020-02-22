//
//  AddWaypoint+GoogleMap.swift
//  Tripp
//
//  Created by Bharat Lal on 21/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

extension AddWaypointToTripViewController: GMSMapViewDelegate{
    //MARK: Google map delegate
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if !isDragignMarker{
            addressFromGeocodeCoordinate(coordinate: coordinate)
        }
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        isDragignMarker = true
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        addressFromGeocodeCoordinate(coordinate: marker.position)
        isDragignMarker = false
    }
    //MARK: Helper functions
    func addressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        if (trip?.waypoints.count)! > 24{
            AppToast.showErrorMessage(message: maxPlaceslimitMessage)
            return
        }
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            
            guard let response = response else{
                if self.trip?.drivingMode == TripType.Sea.rawValue{
                    self.createSeaWayPointWithCoordinate(coordinate)
                    
                }else{
                    AppToast.showErrorMessage(message: invalidLocation)
                }
                return
                
            }
            
            if let address = response.firstResult() {
                let lines = address.lines! as [String]
                DLog(message: lines as AnyObject)
                let point = Wayponit.createWaypointFromAddress(address)
                point.isTemp = true
                if let _ = self.currentDropMarker{
                    self.trip?.waypoints.removeLast() // user added another marker without saving last added
                }
                self.addWaypointMarkerOn(coordinate, waypoint: point)
                self.addWaypointAndDrawTrip(point: point)
                
            }else{
                AppToast.showErrorMessage(message: invalidLocation)
            }
        }
    }
        
    func addWaypointAndDrawTrip(point: Wayponit){
        self.showSelectedAddress(waypoint: point)
        if self.trip?.waypoints.count == 0 && isShowSavedPoptip == false{
            isShowSavedPoptip = true
            self.showTip(popType: .savePoint)
        }
        self.trip?.waypoints.append(point)
        if self.trip!.waypoints.count > 1 {
            self.drawRoute(self.trip!)
        }
    }
    
    func createSeaWayPointWithCoordinate(_ coordinate: CLLocationCoordinate2D){
        let point = Wayponit.createWaypointWithCordinate(coordinate, waypointIndex: trip!.waypoints.count + 1)
        if let _ = self.currentDropMarker{
            self.trip?.waypoints.removeLast() // user added another marker without saving last added
        }
        self.addWaypointMarkerOn(coordinate, waypoint: point)
        self.addWaypointAndDrawTrip(point: point)
    }
    func addWaypointMarkerOn(_ position: CLLocationCoordinate2D, waypoint:Wayponit){
        clearCurrentMarker()
        self.currentDropMarker = self.dropMarkerOn(position, waypoint: waypoint, isDraggable: true)
    }
    func clearCurrentMarker(){
        if let _ = self.currentDropMarker{
            self.currentDropMarker?.map = nil
            self.currentDropMarker = nil
        }
    }
    func dropMarkerOn(_ position: CLLocationCoordinate2D, waypoint:Wayponit, isDraggable: Bool) ->GMSMarker {
        let marker = GMSMarker(position: position)
        marker.userData = waypoint.address
        marker.title = waypoint.name
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
        marker.isDraggable = isDraggable
       // marker.accessibilityLabel = "current"
        marker.icon = UIImage(named: icMarkerWaypoint)
        //marker.map = self.mapView //xr
        return marker
    }
    
    func drawRoute(_ trip: Route){
        //xr
        /*if trip.drivingMode == TripType.Road.rawValue{
            drawRoadTrip(trip)
        }else if trip.drivingMode == TripType.Sea.rawValue{
            self.mapView.drawSeaTrip(trip)
        }else if trip.drivingMode == TripType.Aerial.rawValue{
            self.mapView.drawAerialTrip(trip)
        }*/
    }
    func drawRoadTrip(_ trip: Route){
        let routeManager = RoutesManager()
        routeManager.polylineForTrip(trip) { (route, error) in
            guard let aRoute = route else{
                return
            }
            Utils.mainQueue {
                //self.drawPath(aRoute)
                //self.mapView.drawTrip(route: aRoute, color: UIColor.tripColor(), shouldClear: true) //xr
            }
        }
    }
    
    // user tapped on marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.openLocationAlertAction(marker: marker)
        return true
    }
    // draw trip
    private func drawPath(_ route: Route){
        guard let polylineString = route.polylineString as String? else {
            return
        }
        clearCurrentMarker()
        self.addMarker(route)
        if let polyline = tripPolyline {
            polyline.map = nil
        }
        if let path: GMSPath = GMSPath(fromEncodedPath: polylineString){
            tripPolyline = GMSPolyline(path: path)
            tripPolyline?.isTappable = false
            tripPolyline?.strokeWidth = polylineStrokWidth
            //tripPolyline?.map = self.mapView //xr
            tripPolyline?.strokeColor = UIColor.tripColor()
        }
        
    }
    private func addMarker(_ trip: Route) {
        let endLat = Double(trip.waypoints.last!.latitude)
        let endLon = Double(trip.waypoints.last!.longitude)
        let endPosition = CLLocationCoordinate2D(latitude: endLat!, longitude: endLon!)
        self.currentDropMarker = GMSMarker(position: endPosition)
        currentDropMarker?.icon = UIImage(named: isMarkerTripEnd)
        currentDropMarker?.isDraggable = true
        //currentDropMarker?.map = self.mapView //xr
    }
    //-- Open location alert action
    func openLocationAlertAction(marker: GMSMarker){
        let alertController = UIAlertController(title: nil, message: chooseOption, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        
        let openMap = UIAlertAction(title: "Open in Map", style: .default) { (camera) -> Void in
            marker.openMap()
        }
        
        let addToWishList = UIAlertAction(title: "Add to wish list", style: .default) { (camera) -> Void in
            marker.addLocationToWishList()
        }
        
        alertController.addAction(openMap)
        alertController.addAction(addToWishList)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
