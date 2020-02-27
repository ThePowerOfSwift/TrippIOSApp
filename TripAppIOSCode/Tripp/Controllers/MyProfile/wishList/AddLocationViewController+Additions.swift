//
//  AddLocationViewController+Additions.swift
//  Tripp
//
//  Created by Bharat Lal on 16/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

extension AddLocationViewController: GMSMapViewDelegate, UITextFieldDelegate{
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
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            guard let response = response else{
                AppToast.showErrorMessage(message: invalidLocation)
                return
            }
            if let address = response.firstResult() {
                let lines = address.lines! as [String]
                let fullAddress = lines.joined(separator: "\n")
                DLog(message: lines as AnyObject)
                let point = Wayponit.createWaypointFromAddress(address)
                point.isTemp = true
                self.mapView.clear()
                self.dropMarkerOn(coordinate, withAddress: fullAddress)
                self.selectWaypoint(point)
                
            }else{
                AppToast.showErrorMessage(message: invalidLocation)
            }
        }
    }
    func selectWaypoint(_ waypoint: Wayponit){
        self.savePointButton.isHidden = false
        self.messageLabel.text = waypoint.address
        self.selectedLocation = waypoint
    }
    func dropMarkerOn(_ position: CLLocationCoordinate2D, withAddress address: String) {
        let marker = GMSMarker(position: position)
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
        marker.isDraggable = true
        marker.userData = address
        marker.title = address
        marker.icon = UIImage(named: icMarkerWaypoint)
        marker.map = self.mapView
    }
    
    //MARK: UITextField delegate
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
                self.mapView.moveMapToUserlocation(CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                
            })
        }
    }
}
