//
//  PlaceFinderOperation.swift
//  Tripp
//
//  Created by Monu on 07/09/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceFinderOperation: Operation {
    
    var handler: PlaceFinderHandler?
    
    var radius: Double = 0.0
    var coordinate: CLLocationCoordinate2D!
    var place: String = ""
    
    required init(place: String, radius:Double, coordinate: CLLocationCoordinate2D, handler: PlaceFinderHandler?) {
        self.handler = handler
        self.radius = radius
        self.coordinate = coordinate
        self.place = place
        super.init()
    }
    
    override func main() {
        if self.isCancelled{
            return
        }
        
        var params: [String: Any] = ["location":  "\(coordinate.latitude),\(coordinate.longitude)"]
        params["radius"] = radius
        params["key"] = ConfigurationManager.googleServicesAPIKey()
        params["type"] = self.place
        fetchPlaces(params: params)
    }
    
    func fetchPlaces(params: [String:Any]){
        APIDataSource.fetchPlaces(params: params) { (places, nextPageToken, error) in
            if places != nil {
                Utils.mainQueue {
                    if let handler = self.handler {
                        handler(places, nil)
                    }
                }
                
                if !(nextPageToken?.isEmpty)!{
                    var nextParam: [String: Any] = ["pagetoken": nextPageToken!]
                    nextParam["key"] = ConfigurationManager.googleServicesAPIKey()
                    self.fetchPlaces(params: nextParam)
                }
            }
        }
    }
    
    
}
