//
//  GMSMarker+Addition.swift
//  Tripp
//
//  Created by Monu on 11/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit

extension GMSMarker {
    
    func addLocationToWishList(){
        AppLoader.showLoader()
        var address = ""
        if let addr = self.userData as? String {
            address = addr
        }
        
        APIDataSource.addLocationToWistList(service: .addLocationWish(latitude: "\(self.position.latitude)", longitude: "\(self.position.longitude)", address: address, name: self.title ?? "", date: "")) { (message, errorMessage) in
            AppLoader.hideLoader()
            if errorMessage != nil{
                AppToast.showErrorMessage(message: errorMessage!)
            }
            else{
                AppToast.showSuccessMessage(message: message!)
            }
        }
    }
    
    func openMap() {
        if UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL) {
            self.openInGoogleMap()
        }
        else if !self.openInAppleMap(){
            self.openGoogleMapInBrowser()
        }
    }
    
    private func openInAppleMap() -> Bool{
        let regionDistance:CLLocationDistance = 10000
        let regionSpan = MKCoordinateRegionMakeWithDistance(self.position, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ] as [String : Any]
        let placemark = MKPlacemark(coordinate: self.position, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        return mapItem.openInMaps(launchOptions: options)
    }
    
    private func openInGoogleMap(){
        let mapUrl = "comgooglemaps://?saddr=&daddr=\(self.position.latitude),\(self.position.longitude)&directionsmode=driving"
        UIApplication.shared.open(URL(string: mapUrl)!, options: [:], completionHandler: nil)
    }
    
    private func openGoogleMapInBrowser(){
        let mapUrl = "http://maps.google.com/maps?saddr=&daddr=\(self.position.latitude),\(self.position.longitude)&directionsmode=driving"
        UIApplication.shared.open(URL(string: mapUrl)!, options: [:], completionHandler: nil)
    }
}
