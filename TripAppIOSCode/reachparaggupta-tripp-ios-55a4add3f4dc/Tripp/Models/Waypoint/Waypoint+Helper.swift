//
//  Waypoint+Helper.swift
//  Tripp
//
//  Created by Bharat Lal on 13/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import RealmSwift

extension Wayponit{
    
    var imagesCount: Int{
        get{
            return self.mediaCount(type: MediaType.photo.rawValue)
        }
    }
    
    var videoCount: Int{
        get{
            return self.mediaCount(type: MediaType.video.rawValue)
        }
    }
    
    func mediaCount(type: Int) -> Int{
        let result = self.waypointMedia.filter( { $0.type == type })
        return result.count
    }
    func coordinates() -> String{
        return latitude + "," + longitude
    }
    class func createWaypointFromAddress(_ address: GMSAddress) -> Wayponit{
        let waypoint = Wayponit()
        waypoint.name = address.thoroughfare != nil ? address.thoroughfare! : waypointTitle
        let lines = (address.lines! as [String]).filter({!$0.isEmpty})
        let fullAddress = lines.joined(separator: ", ")
        waypoint.address = fullAddress
        waypoint.city = address.locality != nil ? address.locality! : ""
        waypoint.state = address.administrativeArea != nil ? address.administrativeArea! : ""
        waypoint.country = address.country != nil ? address.country! : ""
        waypoint.latitude = String(address.coordinate.latitude)
        waypoint.longitude = String(address.coordinate.longitude)
        
        return waypoint
    }
    
    class func createWaypointWithCordinate(_ coordinate: CLLocationCoordinate2D, waypointIndex: Int) -> Wayponit{
        let waypoint = Wayponit()
        waypoint.name = waypointTitle
        waypoint.address = waypointTitle + " \(waypointIndex)"
        waypoint.latitude = String(coordinate.latitude)
        waypoint.longitude = String(coordinate.longitude)
        return waypoint
    }
    
    
    func updateAddress(_ waypoint: Wayponit){
        self.name = waypoint.name
        self.address = waypoint.address
        self.city = waypoint.city
        self.state = waypoint.state
        self.country = waypoint.country
    }
    func updateLiveTripCurrentPoint(point: Wayponit){
        do{
            let realm = try Realm()
            try realm.write {
                self.updateAddress(point)
            }
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }

    }
    func mediaAssets() -> [MediaAsset]{
        var assets:[MediaAsset] = []
        for media in waypointMedia {
            let asset = MediaAsset()
            asset.mediaType = MediaType(rawValue: media.type)!
            asset.imageURL = media.sourcePath
            asset.caption = media.caption
            asset.address = media.address
            asset.city = media.city
            asset.state = media.state
            asset.country = media.country
            asset.latitude = media.latitude
            asset.longitude = media.longitude
            assets.append(asset)
        }
        return assets
    }
    
    func location() -> CLLocationCoordinate2D{
        let lat = Double(self.latitude)!
         let lon = Double(self.longitude)!
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
    }
    
    //-- Delete waypoints
    func deleteWaypoint(tripId:Int, completion: @escaping (_ message: String?, _ error: String?) -> ()){
        AppLoader.showLoader()
        APIDataSource.deleteWaypoint(waypointId: self.waypointId, tripId: tripId) { (message, error) in
            AppLoader.hideLoader()
            completion(message, error)
        }
    }
    
    //MARK: Copy of a object
    override func copy() -> Any {
        let copy = Wayponit()
        copy.waypointId = self.waypointId
        copy.name = self.name
        copy.address = self.address
        copy.address = self.address
        copy.latitude = self.latitude
        copy.longitude = self.longitude
        copy.indexNumber = self.indexNumber
        copy.city = self.city
        copy.state = self.state
        copy.country = self.country
        copy.isTemp = self.isTemp
        copy.waypointMedia = List<WaypointMedia>()
        for media in self.waypointMedia {
            copy.waypointMedia.append(media.copy() as! WaypointMedia)
        }
        return copy
    }
    
}
