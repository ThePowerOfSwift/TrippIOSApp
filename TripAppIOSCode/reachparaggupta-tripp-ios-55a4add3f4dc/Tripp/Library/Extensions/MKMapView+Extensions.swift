//
//  MKMapView+Extensions.swift
//  Tripp
//
//  Created by MOHAVE on 22/02/20.
//  Copyright © 2020 Appster. All rights reserved.
//

import Foundation
import UIKit
import MapKit


extension MKMapView {

    func moveMapTolocation(_ location: CLLocation) {
        var region = MKCoordinateRegion()
        region.center = location.coordinate
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.05
        span.longitudeDelta = 0.05
        region.span = span
        self.setRegion(region, animated: true)
    }
    
    func clear() {
        self.clear_annotations()
        self.clear_overlays()
    }
    
    func clear_annotations() {
        self.removeAnnotations(self.annotations)
    }
    
    func clear_overlays() {
        self.removeOverlays(self.overlays)
    }
    
    func addWishLocationMarker(_ wish: LocationWish) {
        /*let marker = LocationWishMarker(position: wish.coordinate())
        marker.locationWish = wish
        marker.icon = wish.isCompleted == 0 ? UIImage(named: starMarkerBlue) : UIImage(named: starMarkerGreen)
        //marker.map = self
        */
        
        /*let annotationView = MKAnnotationView.init()
        annotationView.image = wish.isCompleted == 0 ? UIImage(named: starMarkerBlue) : UIImage(named: starMarkerGreen)
        annotationView.annotation = MKAnnotation.
        self.addAnnotation(annotationView)*/
       }
    
    func addPlaceWishMarker(_ wish: Place) {
           /*let marker = PlaceWishMarker(position: wish.coordinate())
           marker.placeWish = wish
           marker.icon = wish.isMarkedAsComplete == 0 ? UIImage(named: starMarkerBlue) : UIImage(named: starMarkerGreen)
           marker.map = self*/
       }
   }


