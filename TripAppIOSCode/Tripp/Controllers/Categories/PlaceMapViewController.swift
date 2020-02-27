//
//  PlaceMapViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 24/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    var markers = [GMSMarker]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLoaded()
        mapView.delegate = self
        //showCurrentLocationOnMap()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        mapView.setMinZoom(8.0, maxZoom: 18.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dataLoaded() {
        guard let parentVC = parent as? PlacesViewController else {
            return
        }
        for place in parentVC.places {
            dropMarkerOn(place)
        }
        zoomToShowAllPlaces()
    }
    // MARK: - private
    private func loadNiB() -> MarkerInfoWindow {
        let infoWindow = MarkerInfoWindow.instanceFromNib() as! MarkerInfoWindow
        return infoWindow
    }
    private func loadNiBWithText(_ text: String) -> MarkerInfoWindow {
        let infoWindow = MarkerInfoWindow.instanceFromNib() as! MarkerInfoWindow
        let width = text.widthOfString(usingFont: UIFont.openSensSemiBold(size: 14))
        infoWindow.frame.size.width = (width > 300 ? 300 : width) + 39
        return infoWindow
    }
    private func showCurrentLocationOnMap(){
        LocationManager.sharedManager.currentLocation(complitionHandler: {(location, error) in
            guard let _ = error else {
                self.mapView.moveMapToUserlocation(location!)
                return
            }
        })
    }
    private func dropMarkerOn(_ place: Place) {
        guard let lat = Double(place.latitude), let long =  Double(place.longitude) else {
            return
        }
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let marker = GMSMarker(position: position)
        marker.userData = place
        marker.title = place.name
        marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0)
        marker.icon = #imageLiteral(resourceName: "icWayponiMarker")
        marker.map = self.mapView
        markers.append(marker)
    }
}
extension PlaceMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let category = (parent as? PlacesViewController)?.category, category.isPurchased == 0 {
            presentCategoryIAPWith(category)
            return
        }
        guard let place = marker.userData as? Place else {
            return
        }
        pushPlacesDetails(place)
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = loadNiBWithText(marker.title ?? "")
        view.titleLabel.text = marker.title
        view.bgView.layer.cornerRadius = 9.0
        return view
    }
    func zoomToShowAllPlaces() {
        let bounds = markers.reduce(GMSCoordinateBounds()) {
            $0.includingCoordinate($1.position)
        }
        
        mapView.animate(with: .fit(bounds, withPadding: 30.0))
    }
}
