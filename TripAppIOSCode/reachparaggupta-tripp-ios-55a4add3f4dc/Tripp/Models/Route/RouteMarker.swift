//
//  RouteMarker.swift
//  Tripp
//
//  Created by Bharat Lal on 11/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

class RouteMarker: GMSMarker {
    var route: Route!
}
class LocationWishMarker: GMSMarker {
    var locationWish: LocationWish!
}
class PlaceWishMarker: GMSMarker {
    var placeWish: Place!
}
class RoutePolyline: GMSPolyline{
    var route: Route!
}
