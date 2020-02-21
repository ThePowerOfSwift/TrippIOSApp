//
//  NearByPlace.swift
//  Tripp
//
//  Created by Monu on 14/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreLocation

class NearByPlace: NSObject{
    
    var placeId: String?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var types: [String] = []
    var placeDescription: String?
    
    required init(value: [String:Any]) {
        super.init()
        self.parse(value: value)
    }
    
    private func parse(value: [String: Any]){
        
        if let placeId = value["place_id"] as? String{
            self.placeId = placeId
        }
        
        if let name = value["name"] as? String{
            self.name = name
        }
        
        if let types = value["types"] as? [String]{
            self.types = types
        }
        if let placeDescription = value["description"] as? String{
            self.placeDescription = placeDescription
        }
        guard let geometry = value["geometry"] as? [String:Any], let location = geometry["location"] as? [String:Any], let latitude = location["lat"] as? Double, let longitude = location["lng"] as? Double else{
            return
        }
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    public func marker(searchPlace: String) -> String{
        var imageName:String!
        switch searchPlace {
        case filterPark:
             imageName = icMarkerPark
        case filterHotels:
            imageName = icMarkerHotels
        case filterLandMark:
             imageName = icMarkerLandmark
        case filterCampGround:
            imageName = icMarkerCampGround
        case filterGasStation:
            imageName = icMarkerGasStation
        default:
            imageName = ""
        }
        return imageName
    }
}
