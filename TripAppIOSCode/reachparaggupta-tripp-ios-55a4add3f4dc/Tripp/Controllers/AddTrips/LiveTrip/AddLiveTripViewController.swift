//
//  AddLiveTripViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 18/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Social
class AddLiveTripViewController: AddTripBaseViewController {
    //MARK: Variables/IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapView_apple: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripDatelabel: UILabel!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedlabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var titleTrailingSpace: NSLayoutConstraint!
    var trip: Route?
    var originalTrip: Route?
    var isEditMode = false
    //var mapTypeButton: UIButton! //xr
    var mapTypeButton: UIButton?
    var fromGroups = false
    var isTripDetail = false
    
    let trackingManager = LiveTrackingManager.sharedManager
    lazy var tripMediaViewController: LiveTripMediaViewController = {
        return addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.liveTripMediaVC.rawValue) as! LiveTripMediaViewController
    }()
    
    //xr
    private var crumbs: CrumbPath?
    private var crumbPathRenderer: CrumbPathRenderer?
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        mapTypeButton = self.mapView.addMapTypeToggleButton()
        
        //xr
        self.mapView.isHidden = true
        self.mapView_apple.showsUserLocation = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tripMediaViewController.mediaView.roundCorner([.topLeft, .topRight], radius: 12)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let location = self.mapView.myLocation {
            self.mapView.moveMapToUserlocation(location, withZoom: 15.0)
        }
        
        //xr
        let location = self.mapView_apple.userLocation
        self.mapView_apple.moveMapTolocation(CLLocation.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Private / Helper
    private func setupView() {
        tripMediaViewController.isEditMode = isEditMode
        self.addMediaView()
        self.initializeCurrentTrip()
        self.fillTripdetails()
        self.addShadowAndCornerRadius()
        setupViewInEditMode()
        self.mapView.drawRoute(route: trip!)
        self.mapView.setMinZoom(8.0, maxZoom: 15.0)
    }
    func liveTripFinished(_ notification: Notification) {
        self.trackingManager.cleanLiveTrackingDB()
    }
    func shareMyTrip() {
        if self.tripMediaViewController.isOpen == true {
            self.tripMediaViewController.openOrCloseViewTapped(nil)
            self.perform(#selector(AddLiveTripViewController.captureScreen), with: nil, afterDelay: 0.4)
        } else {
            captureScreen()
        }
    }
    @objc private func captureScreen() {
        if let route = trip {
            let tempRoute = route.copy() as! Route
            self.mapView.moveCameraOnCurrentPath(route: tempRoute)
            toggleControlls(true)
            self.perform(#selector(AddLiveTripViewController.shareNow), with: tempRoute, afterDelay: 0.3)
        }
    }
    @objc private func shareNow(_ route: Route){
        if let screenshot = self.view.captureScreenshot(){
            if isEditMode == true {
                ShareManager.shareAppActionSheet(onController: self, handler: { (isCancel, isFacebook) in
                    if !isCancel {
                        if isFacebook {
                            Utils.shareImageOnFacebook(screenshot, type: .bike, trip: self.trip!, controller: self)
                        } else {
                            route.share(screenshot, shouldShareUrl: false)
                        }
                    }
                })
            } else{
                pushToShareTrip(screenshot, route)
                self.trackingManager.cleanLiveTrackingDB()
            }
        }
        toggleControlls(false)
    }
    private func toggleControlls(_ isHidden: Bool) {
        self.tripMediaViewController.view.isHidden = isHidden
        self.locationButton.isHidden = isHidden
        self.closeButton.isHidden = isHidden
        self.mapTypeButton?.isHidden = isHidden //xr
        if isEditMode == true {
            shareButton.isHidden = isHidden
        }
    }
    private func setupViewInEditMode(){
        if isEditMode{
            tripNameTextField.isHidden = fromGroups
            tripNameLabel.isHidden = !fromGroups
            tripNameTextField.text = trip?.name
            trackingManager.initializeInEditModeFrom(trip: trip!)
            self.locationButton.isHidden = !fromGroups
            //self.mapView.moveCameraOnCurrentPath(route: self.trip!)
            setupInfoView()
            titleTrailingSpace.constant = 35
        }else{
            self.mapView.isMyLocationEnabled = true
            self.locationTapped(nil)
            self.locationButton.isHidden = false
            tripNameTextField.isHidden = true
            tripNameLabel.isHidden = false
            self.perform(#selector(AddLiveTripViewController.locationTapped(_:)), with: nil, afterDelay: 0.3)
            shareButton.isHidden = true
        }
        if fromGroups == true {
            tripMediaViewController.deleteButton.isHidden = true
            tripMediaViewController.finishButton.isHidden = true
            //tripMediaViewController.recordButton.isHidden = true
        }
    }
    private func setupInfoView(){
        durationLabel.text = trip?.totalTime
        distanceLabel.text = trip?.sortDistanceInMiles ?? ""
        if let timeString = trip?.totalTime, let disString = trip?.sortDistanceInMiles {
            let time = timeString.components(separatedBy: " ").first
            let distance = disString.components(separatedBy: " ").first
            if let ts = time, let  ds = distance, let t = Double(ts), let d = Double(ds) {
                let speed = (d/t > 0 ? d/t : 0)
                speedlabel.text = "\(speed.rounded(toPlaces: 2)) mph"
            }
        }
    }
    private func fillTripdetails(){
        self.tripNameLabel.text = trip?.name
        self.tripDatelabel.text = trip?.createdAt.convertFormatOfDate(AppDateFormat.sortDate)
    }
    
    private func addShadowAndCornerRadius(){
        headerView.roundCorner([.bottomLeft, .bottomRight], radius: 12)
    }
    
    private func initializeCurrentTrip(){
        if isEditMode{
            self.trackingManager.trip = trip
            return
        }
        if trip == nil{
            trip = Route.currentTrip()
            self.trackingManager.assignTrackingManager(trip: trip!)
            self.tripMediaViewController.startRecording()
        }
        else{
            self.trackingManager.cleanLiveTrackingDB()
            trip?.addLiveTripWaypoint()
            trip?.saveTrip()
        }
        self.trackingManager.trip = trip
    }
    
    func updateStartEndCoordinateAndCalculateDistance(){
        if let startLocation = self.trackingManager.startLocation, let lastLocation = self.trackingManager.currentLocation{
            self.trip?.updateLiveTripWaypointAndDistance(startLocation: startLocation, lastLocation: lastLocation)
        }
    }
    
    private func currentLocation(location: CLLocation){
        if !self.trackingManager.isStarted || self.trackingManager.currentLocation == nil{
            self.trackingManager.startTracking(location, isTripStarted: true)
            tripMediaViewController.addressFromGeocodeCoordinate(coordinate: (trackingManager.startLocation?.location)!, isStartLocation: true)
        }
        
        self.drawLiveTrip(firstLocation: (self.trackingManager.currentLocation?.location)!, secondPoint: location.coordinate)
        self.trackingManager.saveLocation(location, isForce: false)
        self.recenterMapIfNeeded(location)
        redrawPathIfNeeded()
        durationLabel.text = (trip?.calculateTotalTime() ?? "") + " hours"
        let speed = location.speed * 2.236936284
        let speedVal = speed > 0 ? speed : 0
        speedlabel.text = "\(speedVal.rounded(toPlaces: 2)) mph"
        distanceLabel.text = trip?.sortDistanceInMiles ?? ""
        
    }
    
    private func redrawPathIfNeeded(){
        if self.trackingManager.locations.count >= 20{
            
            if let encodedPath = trip?.encodedPath {
                trip?.updatePolyline(encodedPath)
                mapView.clear()
                mapView.drawRoute(route: trip!)
                trackingManager.locations.removeAll()
            }
        }
    }
    
    func startContinueFetchLocation(){
        crumbs = nil
        crumbPathRenderer = nil
        self.mapView_apple.removeOverlays(mapView_apple.overlays)
        
        //-- Start significatnt locations
        SignificantLocationManager.sharedInstance.startSignificantLocationUpdate()
        
        //-- Fetching continues locations
        LocationManager.sharedManager.isFirstLocationFound = false
        LocationManager.sharedManager.continueFetchLocation { (location, error) in
            if let loc = location, error == nil {
                LiveTrackingManager.sharedManager.writeData(location: loc, mode: "ContinueFetchLocation")
                if let lastLatitude = self.trackingManager.currentLocation?.lat, lastLatitude == loc.coordinate.latitude.description {
                    return
                }
                //self.currentLocation(location: loc) //xr
                self.getNewLocation(newLocation: loc)
            }
        }
    }
    
    private func addMediaView(){
        self.add(asChildViewController: tripMediaViewController)
        self.view.bringSubview(toFront: tripMediaViewController.view)
        self.addShadowAndBorderOnMediaView()
        self.view.bringSubview(toFront: locationButton)
        self.view.bringSubview(toFront: infoView)
    }
    
    //MARK: Private Methods
    private func recenterMapIfNeeded(_ location: CLLocation){
        let region = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(region: region)
        if !bounds.contains(location.coordinate){
            self.mapView.moveMapToUserlocation(location, withZoom: 15)
        }
    }
    private func addShadowAndBorderOnMediaView(){
        // tripMediaViewController.delegate = self
        let yPoint = Global.screenRect.size.height - 161
        let height = Global.screenRect.size.height - 20
        let y = Devices.deviceName() == Model.iPhoneX.rawValue ? yPoint - 35 : yPoint
        
        tripMediaViewController.view.frame.origin.y = y
        tripMediaViewController.view.frame.size.height = Devices.deviceName() == Model.iPhoneX.rawValue ? (height - 30) : height
        tripMediaViewController.view.layer.masksToBounds = false
        tripMediaViewController.view.layer.shadowOffset = CGSize(width: 2, height: -6)
        tripMediaViewController.view.layer.shadowRadius = 11
        tripMediaViewController.view.layer.shadowOpacity = 11
        tripMediaViewController.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.21).cgColor
        tripMediaViewController.categoryView.isHidden = true
    }
    @objc func enableCloseButton(){
        closeButton.isEnabled = true
    }
    //MARK: IBActions
    @IBAction func locationTapped(_ sender: Any?) {
        let location  = mapView.myLocation
        self.mapView.moveMapToUserlocation(location ?? CLLocation(), withZoom: 15)
    }
    @IBAction func shareTapped(_ sender: Any?) {
        if isEditMode{
            captureScreen()
        }
    }
    @IBAction func closeButtonTapped(_ sender: Any?){
        if isEditMode{
            self.dismiss(animated: true, completion: nil)
            return
        }
        closeButton.isEnabled = false
        self.perform(#selector(AddLiveTripViewController.enableCloseButton), with: nil, afterDelay: 0.5)
        let alert = AddRoutesAlertPopupView(cancelTripWarning, actionButtonTitle: removeTitle) { buttonIndex in
            if buttonIndex == 2{
                self.dismiss(animated: true, completion: nil)
                LocationManager.sharedManager.stopFetchingLocation()
                self.trackingManager.exit()
                self.trackingManager.cleanLiveTrackingDB()
                AppUserDefaults.set(value: false, for: .livetrackingOn)
            }
        }
        alert.displayView(onView: windowGlobal != nil ? windowGlobal! : self.view)
    }
    
    //MARK: Server API
    func saveTripAPI(_ fileName: String){
        Utils.mainQueue { 
            self.trip?.updateTripStats(fileUrl: fileName, groupId: self.tripMediaViewController.selectedGroup?.groupId)
            //self.trip?.groupId = self.tripMediaViewController.selectedGroup?.groupId ?? 0
            self.trip?.saveTrip(handler: { (trip, error) in
                AppLoader.hideLoader()
                if error == nil {
                    self.trackingManager.exit()
                    LiveTrackingManager.sharedManager.writeToFile("---------------- Stop Recording ---------------")
                    AppToast.showSuccessMessage(message: "Your trip saved successfully")
                    self.shareMyTrip()
                    AnalyticsManager.addTrip(trip: trip!)
                    AdMobVideoManager.shared.presentVideoAd()
                    AWSImageManager.sharedManger.uploadLogFileToS3()
                }
                else{
                    AppToast.showErrorMessage(message: error!)
                }
            })
        }
        
    }
    
    func editTripAPI() {
        if tripNameTextField.isEmpty() {
            AppToast.showErrorMessage(message: addTripNameMessage)
        }
        else{
            trip?.name = tripNameTextField.text!
            AppLoader.showLoader()
            self.trip?.groupId = self.tripMediaViewController.selectedGroup?.groupId ?? 0
            self.trip?.saveTrip(handler: { (trip, error) in
                AppLoader.hideLoader()
                if error == nil {
                    if self.isEditMode {
                        self.originalTrip?.copyObject(fromRoute: trip!)
                        self.originalTrip?.polylineString = self.trip?.polylineString
                        self.dismiss(animated: true, completion: nil)
                        AppNotificationCenter.post(notification: AppNotification.updateTrip, withObject: nil)
                    }
                    else{
                        self.openMyTrip()
                    }
                }
                else{
                    AppToast.showErrorMessage(message: error!)
                }
            })
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension AddLiveTripViewController : MKMapViewDelegate {
    private func coordinateRegionWithCenter(_ centerCoordinate: CLLocationCoordinate2D, approximateRadiusInMeters radiusInMeters: CLLocationDistance) -> MKCoordinateRegion {
        
        let radiusInMapPoints = radiusInMeters * MKMapPointsPerMeterAtLatitude(centerCoordinate.latitude)
        let radiusSquared = MKMapSize(width: radiusInMapPoints, height: radiusInMapPoints)
        
        let regionOrigin = MKMapPointForCoordinate(centerCoordinate)
        var regionRect = MKMapRect(origin: regionOrigin, size: radiusSquared)
        
        //regionRect = regionRect.MKMapRectOffset(dx: -radiusInMapPoints/2, dy: -radiusInMapPoints/2)
        regionRect = MKMapRectOffset(regionRect, -radiusInMapPoints/2, -radiusInMapPoints/2)
        
        // clamp the rect to be within the world
        //regionRect = regionRect.intersection(.MKMapRectWorld)
        regionRect = MKMapRectIntersection(regionRect, MKMapRectWorld);
        
        //let region = MKCoordinateRegion(regionRect)
        let region = MKCoordinateRegionForMapRect(regionRect)
        return region
    }
    
    
    func getNewLocation(newLocation: CLLocation) {
        //NSLog("\(#file):\(#line)")
        print("New Loc: \(newLocation.description)")
        
        if self.crumbs == nil {
            
            crumbs = CrumbPath(center: newLocation.coordinate)
            self.mapView_apple.add(self.crumbs!, level: .aboveRoads)
            
            // on the first location update only, zoom map to user location
            let newCoordinate = newLocation.coordinate
            
            // default -boundingMapRect size is 1km^2 centered on coord
            let region = self.coordinateRegionWithCenter(newCoordinate, approximateRadiusInMeters: 2500)
            
            self.mapView_apple.setRegion(region, animated: true)
        } else {
            
            var boundingMapRectChanged = false
            var updateRect = self.crumbs!.addCoordinate(newLocation.coordinate, boundingMapRectChanged: &boundingMapRectChanged)
            if boundingMapRectChanged {
                self.mapView_apple.removeOverlays(self.mapView_apple.overlays)
                crumbPathRenderer = nil
                self.mapView_apple.add(self.crumbs!, level: .aboveRoads)
                
                let r = self.crumbs!.boundingMapRect
                var pts: [MKMapPoint] = [
                    MKMapPoint(x: r.minX, y: r.minY),
                    MKMapPoint(x: r.minX, y: r.maxY),
                    MKMapPoint(x: r.maxX, y: r.maxY),
                    MKMapPoint(x: r.maxX, y: r.minY),
                ]
                let count = pts.count
                let boundingMapRectOverlay = MKPolygon(points: &pts, count: count)
                self.mapView_apple.add(boundingMapRectOverlay, level: .aboveRoads)
                
            } else if !updateRect.isNull {
                // There is a non null update rect.
                // Compute the currently visible map zoom scale
                let currentZoomScale = MKZoomScale(mapView_apple.bounds.size.width / CGFloat(mapView_apple.visibleMapRect.size.width))
                // Find out the line width at this zoom scale and outset the updateRect by that amount
                let lineWidth = MKRoadWidthAtZoomScale(currentZoomScale)
                updateRect = MKMapRectInset(updateRect, Double(-lineWidth), Double(-lineWidth))
                // Ask the overlay view to update just the changed area.
                
                self.crumbPathRenderer?.setNeedsDisplayIn(updateRect)
            }
        }
        
    }
    
    //MARK: - MapKit
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var renderer: MKOverlayRenderer? = nil
        if overlay is CrumbPath {
            if self.crumbPathRenderer == nil {
                crumbPathRenderer = CrumbPathRenderer(overlay: overlay)
            }
            renderer = self.crumbPathRenderer
        }
        return renderer ?? MKOverlayRenderer(overlay: overlay)
    }
    
}
