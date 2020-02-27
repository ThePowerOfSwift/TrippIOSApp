//
//  GSMMapView+Extension.swift
//  Tripp
//
//  Created by Monu on 12/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

extension GMSMapView{
    @discardableResult
    func addMapTypeToggleButton() -> UIButton{
        let y = (Devices.deviceName() == Model.iPhoneX.rawValue) ? 30.0 : 10.0
        
        let button = UIButton(frame: CGRect(x: Double(Global.screenRect.width - 88), y: y, width: 78.0, height: 78.0))
        button.setImage(UIImage(named: icTerrainView), for: .normal)
        button.addTarget(self, action: #selector(GMSMapView.mapTypeToggleTapped(sender:)), for: .touchUpInside)
        self.addSubview(button)
        return button
    }
    
    @objc func mapTypeToggleTapped(sender: UIButton) {
        let currentType = self.mapType
        let imageName: String
        if currentType == .terrain{
            self.mapType = .normal
            imageName = icTerrainView
        }else{
            self.mapType = .terrain
            imageName = icStandradView
        }
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    
    /**
     * @method drawRoute
     * @discussion Draw Routes on the map
     */
    func drawRoute(route: Route){
        
        if route.drivingMode == TripType.Aerial.rawValue{
            self.drawAerialTrip(route, shouldClear: false)
        }else if route.drivingMode == TripType.Sea.rawValue{
            self.drawSeaTripWithoutClearMap(route)
        }else if route.drivingMode == TripType.Road.rawValue{
            if route.role == UserRole.Admin.rawValue{
                self.drawTrip(route: route, color: route.routeColor())
            }else if route.role == UserRole.Biker.rawValue{
                self.drawTrip(route: route, color: UIColor.tripColor())
            }
        }
    }
    func drawTrip(route: Route, color: UIColor, shouldClear: Bool = false){
        guard let polylineString = route.polylineString as String? else {
            return
        }
        if shouldClear{
            clear()
            addTripMarkers(route, isDraggableEndPoint: true)
        }
        if route.shouldShowWishMarker {
            addWishMarker(route)
        }
        if let path: GMSPath = GMSPath(fromEncodedPath: polylineString){
            drawPath(path, withColor: color, route: route)
        }
    }
    /**
     * @method drawPath
     * @discussion draw path on map
     */
    func drawPath(_ path: GMSPath, withColor color: UIColor = UIColor.tripColor(), route: Route){
        //let polyline = GMSPolyline(path: path)
        let polyline = RoutePolyline(path: path)
        polyline.route = route
        polyline.isTappable = true
        polyline.strokeWidth = polylineStrokWidth
        polyline.map = self
        polyline.strokeColor = color
    }
    /**
     * @method moveMapToUserlocation
     * @discussion move Map to given location
     */
    func moveMapToUserlocation(_ location: CLLocation, withZoom zoom:Float = 8){
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude:location.coordinate.longitude, zoom:zoom)
        self.animate(to: camera)
    }
    /**
     * @method setCameraPositionFor
     * @discussion set camera position (Zoom level) for a given path on map view
     */
    func setCameraPositionFor(path: GMSPath){
        let mapBounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds, withPadding: 60)
     
        self.moveCamera(cameraUpdate)
    }
    func setCameraPositionFor(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D){
        let mapBounds = GMSCoordinateBounds(coordinate: location1, coordinate: location2)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds, withPadding: 60)
        self.moveCamera(cameraUpdate)
    }
    /**
     * @method drawAerialTrip
     * @discussion draw Aerial trip on map
     */
    func drawAerialTrip(_ trip: Route , shouldClear: Bool = true){
        let path: GMSPath
        if shouldClear{
            path = clearMapAndGetPathForTrip(trip)
        }else{
            path = pathForTrip(trip)
        }
        let polyline = RoutePolyline(path: path)
        polyline.route = trip
        polyline.isTappable = true
        polyline.strokeWidth = polylineStrokWidth
        polyline.map = self
        polyline.geodesic = true
        
        let styles = [
            GMSStrokeStyle.solidColor(UIColor.routeProColor()),
            GMSStrokeStyle.solidColor(UIColor.clear)
        ]
        let scale = 1.0 / self.projection.points(forMeters: 1, at: self.camera.target)
        polyline.spans = GMSStyleSpans(polyline.path!, styles, [NSNumber(value: 15.0 * Double(scale)), NSNumber(value: 10.0 * Double(scale))], .geodesic)
    }
    /**
     * @method drawSeaTrip
     * @discussion draw Sea trip on map
     */
    func drawSeaTrip(_ trip: Route){
        let path = clearMapAndGetPathForTrip(trip)
        drawPath(path, route: trip)

    }
    func drawSeaTripWithoutClearMap(_ trip: Route){
        //self.addTripMarkers(trip, isDraggableEndPoint: false)
        let path = pathForTrip(trip)
        drawPath(path,  route: trip)
        
    }
    func clearMapAndGetPathForTrip(_ trip: Route) -> GMSPath{
        self.clear()
        self.addTripMarkers(trip, isDraggableEndPoint: true)
        return pathForTrip(trip)
    }
    func pathForTrip(_ trip: Route) ->GMSPath{
        let path = GMSMutablePath()
        for waypoint in trip.waypoints{
            path.addLatitude(Double(waypoint.latitude)!, longitude: Double(waypoint.longitude)!)
        }
        return path
    }
     func addWishLocationMarker(_ wish: LocationWish) {
        let marker = LocationWishMarker(position: wish.coordinate())
        marker.locationWish = wish
        marker.icon = wish.isCompleted == 0 ? UIImage(named: starMarkerBlue) : UIImage(named: starMarkerGreen)
        marker.map = self
    }
    func addPlaceWishMarker(_ wish: Place) {
        let marker = PlaceWishMarker(position: wish.coordinate())
        marker.placeWish = wish
        marker.icon = wish.isMarkedAsComplete == 0 ? UIImage(named: starMarkerBlue) : UIImage(named: starMarkerGreen)
        marker.map = self
    }
    //MARK: Private
     func addTripMarkers(_ trip: Route, isDraggableEndPoint: Bool = false){
        let startLat = Double(trip.waypoints.first!.latitude)
        let startLon = Double(trip.waypoints.first!.longitude)
        let startPosition = CLLocationCoordinate2D(latitude: startLat!, longitude: startLon!)
        let startMArker = RouteMarker(position: startPosition)
        startMArker.route = trip
        startMArker.icon = UIImage(named: icMarkerWaypoint)
        
        let endLat = Double(trip.waypoints.last!.latitude)
        let endLon = Double(trip.waypoints.last!.longitude)
        let endPosition = CLLocationCoordinate2D(latitude: endLat!, longitude: endLon!)
        let endMArker = RouteMarker(position: endPosition)
        endMArker.icon = UIImage(named: isMarkerTripEnd)
        endMArker.isDraggable = isDraggableEndPoint
        endMArker.route = trip
        
        startMArker.map = self
        endMArker.map = self
    }
    private func addWishMarker(_ wish: Route) {
        let startMarker = wish.startMarker()
        let endMarker = wish.endMarker()
        startMarker.map = self
        endMarker.map = self
    }
    func moveCameraOnCurrentPath(route: Route){
        if route.drivingMode == TripType.Road.rawValue {
            guard let polyline = route.polylineString else {
                return
            }
            guard let path = GMSPath(fromEncodedPath: polyline as String) else {
                return
            }
            self.setCameraPositionFor(path: path)
        }
        else{
            self.setCameraPositionFor(location1: route.startCoordinate(), location2: route.endCoordinate())
        }
    }
}
