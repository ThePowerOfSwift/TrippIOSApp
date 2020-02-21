//
//  AddLiveTrip+MapView.swift
//  Tripp
//
//  Created by Bharat Lal on 22/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

extension AddLiveTripViewController {
    
    
    func drawLiveTrip(firstLocation: CLLocationCoordinate2D, secondPoint: CLLocationCoordinate2D){
        let path = GMSMutablePath()
        path.add(firstLocation)
        path.add(secondPoint)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.tripColor()
        polyline.strokeWidth = polylineStrokWidth
        polyline.map = mapView
    }
}
