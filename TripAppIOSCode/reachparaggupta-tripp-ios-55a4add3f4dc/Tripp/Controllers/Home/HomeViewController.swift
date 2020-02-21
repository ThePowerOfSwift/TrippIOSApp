//
//  HomeViewController.swift
//  Tripp
//
//  Created by Monu on 16/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import MapKit

import GoogleMaps
import NRControls
import AMPopTip

final class HomeViewController: UIViewController {
    //MARK: ------ variables/IBOutlets
    
    //@IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    var myLocation: CLLocation?
    var routesmanager:RoutesManager?
    var routeCounter = 0
    var isFilterApplied = false
    var filters = ""
    var markers = [GMSMarker]()
    var shouldClearFilters = false
    var routes = [Route]()

    //MARK: ------ Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        addNotificationObservers()
        //self.mapView.addMapTypeToggleButton() //xr
        //self.mapView.setMinZoom(8.0, maxZoom: 15.0) //xr
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeTask()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        routesmanager?.pauseAllOperations()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: ------ Private
    private func initializeTask(){
        if shouldClearFilters{
            shouldClearFilters = false
            self.clearFilters()
        } else if isFilterApplied{
            self.applyFilter()
        }
        else {
            routesmanager?.resumeAllOperations(filters: self.filters)
            self.updateRouteCounterInfo(isFetching: self.routeCounter == 0 ? true : false)
        }
    }
    private func addNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.tripDeleted(_:)), name: AppNotification.deleteMyTrip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.tripWishDeleted(_:)), name: AppNotification.deleteRouteWish, object: nil)
        
    }
    private func setupUI(){
        
        //self.mapView.isMyLocationEnabled = true //xr
        //self.mapView.delegate = self //xr
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
                
        self.showCurrentLocationOnMapAndFtechRoutes()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.showNextTip(_:)), name: AppNotification.popTipHide, object: nil)
    }

    @objc func tripDeleted(_ notification: Notification){
        if let deletedRoute = notification.userInfo?["trip"] as? Route, deletedRoute.isAddedFromRoute != 0 {
            let objects = routes.filter({$0.tripId == deletedRoute.isAddedFromRoute}) // isAddedFromRoute is key for route id
            if objects.count > 0{
                objects.first?.isMyTrip = false
            }
        }
    }
    @objc func tripWishDeleted(_ notification: Notification){
        if let deletedWish = notification.userInfo?["tripWish"] as? Route {
            let objects = routes.filter({$0.tripId == deletedWish.tripId})
            if objects.count > 0{
                objects.first?.isMyWish = false
            }
        }
    }
    /**
     * @method showCurrentLocationOnMapAndFtechRoutes
     * @discussion show current location on the Map and start Fteching Routes.
     */
    private func showCurrentLocationOnMapAndFtechRoutes(){
        LocationManager.sharedManager.currentLocation(complitionHandler: {(location, error) in
            guard let _ = error else{
                self.myLocation = location
                //self.mapView.moveMapToUserlocation(location!)//xr
                self.mapView.moveMapTolocation(location!)
                if let parentVC = self.parent as? RoutesBaseViewController, let topView = parentVC.topView{
                    if topView.selectedTab == .Routes{
                        self.fetchAndDrawRoutes(location!)
                        self.perform(#selector(HomeViewController.showTip), with: nil, afterDelay: 1.0)
                    }
                }
                
                return
            }
            self.perform(#selector(HomeViewController.showTip), with: nil, afterDelay: 1.0)
        })
    }
    
    @objc private func showTip(){
       
        guard let isRouteToolTipShown = AppUserDefaults.value(for: .routeTips) else {
            showRouteMainTip()
            return
        }
        
        guard let shown = isRouteToolTipShown as? Bool, shown == true else {
           showRouteMainTip()
            return
        }
    }
    func showRouteMainTip(){
        let tipView = RoutesMainPopTipView(){
            let filterButton = (self.parent as! RoutesBaseViewController).filterButton
            PopTipManager.showTipWith(popType: .filter, inView: self.view, from: filterButton!.frame)
        }
        tipView.displayView(onView: windowGlobal != nil ? windowGlobal! : self.view)
        
    }
    @objc func showNextTip(_ notification: Notification){
        if let popType = notification.userInfo?[notificationPopTypeKey] as? PopTipType {
            
            switch popType {
            case .filter:
                PopTipManager.showTipWith(popType: .routeTap, inView: self.view, from: CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0))
                AppUserDefaults.set(value: true, for: .routeTips)
            default:
                break
            }
        }
    }
    func updateRouteCounterInfo(isFetching: Bool = false){
        (self.parent as? RoutesBaseViewController)?.topView?.updateRouteCounterInfo(self.routeCounter, isFilter: self.isFilterApplied, isFetching: isFetching)
    }
   
    /**
     * @method drawRoute
     * @discussion Draw Routes on the map
     */
    func drawRoute(route: Route){
        self.mapView.drawRoute(route: route)
        routes.append(route)
    }
    /**
     * @method showLocationWish
     * @discussion show user location wishes on the map
     */
    func showLocationWishes(_ wishes: [LocationWish]){
        Utils.mainQueue {
            for wish in wishes {
                self.mapView.addWishLocationMarker(wish)
            }
        }
    }
    func showPlaceWishes(_ wishes: [Place]){
        Utils.mainQueue {
            for wish in wishes {
                self.mapView.addPlaceWishMarker(wish)
            }
        }
    }
    //MARK: ------ IBActions
    @IBAction func filterTapped(_ sender: Any) {
        let topView = (self.parent as! RoutesBaseViewController).topView
        topView?.isUserInteractionEnabled = false
        let filterView = MapFilterView.initializeFilter(selectedFilters: self.filters)
        filterView.displayView(onView: windowGlobal!) { (action, filters) in
            topView?.isUserInteractionEnabled = true
            if action == FilterAction.done {
                if filters.isEmpty == false{
                    self.filters = filters
                    self.isFilterApplied = true
                    self.applyFilter()
                }else if self.isFilterApplied {
                    self.clearFilters()
                }
            }
        }
        
    }
    @IBAction func locationTapped(_ sender: Any) {
        showCurrentLocationOnMapAndFtechRoutes()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController : MKMapViewDelegate {
    
}
