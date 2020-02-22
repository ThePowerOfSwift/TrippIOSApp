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
    
    //@IBOutlet weak var mapView: GMSMapView! //xr
    @IBOutlet weak var mapView: MKMapView! //xr
    
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
    
    //xr
    private var crumbs: CrumbPath?
    private var crumbPathRenderer: CrumbPathRenderer?
    private var drawingAreaRenderer: MKPolygonRenderer?
    
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
        //self.mapView.drawRoute(route: route) //xr
        self.drawRoute(route: route)
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
    
    
    //MARK:-
    
       private func coordinateRegionWithCenter(_ centerCoordinate: CLLocationCoordinate2D, approximateRadiusInMeters radiusInMeters: CLLocationDistance) -> MKCoordinateRegion {
          
           let radiusInMapPoints = radiusInMeters * MKMapPointsPerMeterAtLatitude(centerCoordinate.latitude)
           let radiusSquared = MKMapSize(width: radiusInMapPoints, height: radiusInMapPoints)
           
           let regionOrigin = MKMapPoint(centerCoordinate)
           var regionRect = MKMapRect(origin: regionOrigin, size: radiusSquared)
           
           regionRect = regionRect.offsetBy(dx: -radiusInMapPoints/2, dy: -radiusInMapPoints/2)
           
           // clamp the rect to be within the world
           regionRect = regionRect.intersection(.world)
           
           let region = MKCoordinateRegion(regionRect)
           return region
       }
    
    func drawRoute(route: Route, onMap objMap: MKMapView){
        /*if route.drivingMode == TripType.Aerial.rawValue{
            self.drawAerialTrip(route, shouldClear: false)
        }else if route.drivingMode == TripType.Sea.rawValue{
            self.drawSeaTripWithoutClearMap(route)
        }else if route.drivingMode == TripType.Road.rawValue{
            if route.role == UserRole.Admin.rawValue{
                self.drawTrip(route: route, color: route.routeColor())
            }else if route.role == UserRole.Biker.rawValue{
                self.drawTrip(route: route, color: UIColor.tripColor())
            }
        }*/
        //-----------------------------------------------------
        
        //let newLocation = locations[0]
        //let newLocation = route.currentLocation?.location
        var newLocation : CLLocation = CLLocation.init(latitude: route.currentLocation?.location?.latitude, longitude: route.currentLocation?.location?.longitude)
                
        if self.crumbs == nil {
            
            crumbs = CrumbPath(center: newLocation.coordinate)
            objMap.add(self.crumbs!, level: .aboveRoads)
            
            // on the first location update only, zoom map to user location
            let newCoordinate = newLocation.coordinate
            
            // default -boundingMapRect size is 1km^2 centered on coord
            let region = self.coordinateRegionWithCenter(newCoordinate, approximateRadiusInMeters: 2500)
            
            objMap.setRegion(region, animated: true)
        } else {
            
            var boundingMapRectChanged = false
            var updateRect = self.crumbs!.addCoordinate(newLocation.coordinate, boundingMapRectChanged: &boundingMapRectChanged)
            if boundingMapRectChanged {
                objMap.removeOverlays(objMap.overlays)
                crumbPathRenderer = nil
                objMap.add(self.crumbs!, level: .aboveRoads)
                
                let r = self.crumbs!.boundingMapRect
                var pts: [MKMapPoint] = [
                    MKMapPoint(x: r.minX, y: r.minY),
                    MKMapPoint(x: r.minX, y: r.maxY),
                    MKMapPoint(x: r.maxX, y: r.maxY),
                    MKMapPoint(x: r.maxX, y: r.minY),
                ]
                let count = pts.count
                let boundingMapRectOverlay = MKPolygon(points: &pts, count: count)
                objMap.add(boundingMapRectOverlay, level: .aboveRoads)
            } else if !updateRect.isNull {
                // There is a non null update rect.
                // Compute the currently visible map zoom scale
                let currentZoomScale = MKZoomScale(objMap.bounds.size.width / CGFloat(objMap.visibleMapRect.size.width))
                
                // Find out the line width at this zoom scale and outset the updateRect by that amount
                let lineWidth = MKRoadWidthAtZoomScale(currentZoomScale)
                updateRect = updateRect.insetBy(dx: Double(-lineWidth), dy: Double(-lineWidth))
                
                // Ask the overlay view to update just the changed area.
                self.crumbPathRenderer?.setNeedsDisplay(updateRect)
            }
        }
    }
}
