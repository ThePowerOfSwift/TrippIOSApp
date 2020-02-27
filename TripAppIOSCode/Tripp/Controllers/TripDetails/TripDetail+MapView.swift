//
//  TripDetail+MapView.swift
//  Tripp
//
//  Created by Monu on 09/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps


extension TripDetailsViewController: GMSMapViewDelegate{
    
    //MARK: GMSMapView Delegate Method
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        self.pushRouteDetailsFilter(route: self.route!)
    }
    
}
