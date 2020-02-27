//
//  BaseViewController.swift
//  Tripp
//
//  Created by Monu on 27/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps

class BaseViewController: UIViewController {

    var route:Route?
    var topBar: RouteDetailsTopBar?
    
    @IBOutlet weak var googleMapView: GMSMapView?
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkAndDrawRoute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: Helper
    func addRouteToMyWishList(){
        if route?.isMyTrip == true {
            AppToast.showErrorMessage(message: "You have already completed this route.")
            return
        }
        AppLoader.showLoader()
        route?.addToMyWish(handler: { (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppToast.showSuccessMessage(message: message!)
                self.topBar?.addToWishListButton.isEnabled = false
            }
            else {
                AppToast.showErrorMessage(message: error!)
            }
        })
    }
    
    func checkAndDrawRoute(){
        if let _ = self.route, let _ = self.googleMapView{
            self.drawRouteOnMap()
        }
    }
    
    func drawRouteOnMap(){
        self.googleMapView?.clear()
        if self.route?.drivingMode == TripType.Road.rawValue {
            if let _ = self.route?.polylineString{
                self.googleMapView?.drawRoute(route: self.route!)
            }
            else{
                if let firstCoordinate = self.route?.waypoints.first?.coordinates(), let lastCoordinate = self.route?.waypoints.last?.coordinates() {
                    APIDataSource.fetchRoutePolylineFrom(firstCoordinate, destination: lastCoordinate, waypoints: self.route?.waypointsCoordinates(), completionHandler: { googlePath in
                        if let polyline = googlePath?.polyline{
                            self.route?.polylineString = polyline
                            self.googleMapView?.drawRoute(route: self.route!)
                            self.moveCameraOnCurrentPath()
                        }
                    })
                }
            }
        }
        else{
            self.googleMapView?.drawRoute(route: self.route!)
        }
        self.moveCameraOnCurrentPath()
    }
    
    private func moveCameraOnCurrentPath(){
        self.googleMapView?.moveCameraOnCurrentPath(route: self.route!)
    }

}
