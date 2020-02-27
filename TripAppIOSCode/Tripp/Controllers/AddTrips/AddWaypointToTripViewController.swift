//
//  AddWaypointToTripViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 20/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import MapKit

import GoogleMaps
import RealmSwift

class AddWaypointToTripViewController: UIViewController {
    //MARK: Variables/IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationButton: UIButton!
    
    var trip: Route?
    var originalTrip: Route?
    let topBar = AddTripTopBar.initializeBar()
    var isOpenWaypointView = false
    var isDragignMarker = false
    var currentDropMarker:GMSMarker?
    var isEditMode = false
    var isShowSavedPoptip = false
    var tripManager: TripsManager?
    var completedRoutes: [Route] = []
    var tripPolyline: GMSPolyline?
    var endPointMarker: GMSMarker?
    
    lazy var tripWaypointVC: TripWaypointViewController = {
        return addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.addTripWaypoiint.rawValue) as! TripWaypointViewController
    }()
    
    lazy var searchViewController: SearchViewController = {
        // Instantiate View Controller
        var viewController = homeStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.sarchViewController.rawValue) as! SearchViewController
        
        return viewController
    }()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.mapView.addMapTypeToggleButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAndDrawMyTrips()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeUnSavedWaypoints()
        self.tripManager?.cancelAllOperations()
    }
    
    private func setupView(){
        self.view.addSubview(self.topBar)
        if let myTrip = trip{
            self.topBar.fillTripDetails(name: myTrip.name, date: myTrip.tripDate, tripType: TripType(rawValue: myTrip.drivingMode)!)
        }
        self.mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        topBar.searchField.delegate = self
        topBar.searchField.addTarget(self, action: #selector(AddWaypointToTripViewController.textFieldDidChange(_:)), for: .editingChanged)
        topBar.closeButton.addTarget(self, action: #selector(AddWaypointToTripViewController.closeButtonTapped(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(AddWaypointToTripViewController.popTipOberver(_:)), name: AppNotification.popTipHide, object: nil)
        self.addWaypointView()
        self.setupCameraPosition()
        self.setupEditMode()
        self.bringSearchView()
        self.perform(#selector(AddWaypointToTripViewController.showFirstTip), with: nil, afterDelay: 1.0)
    }
    
    private func setupCameraPosition(){
        if !isEditMode {
            self.showCurrentLocationOnMap()
        }
    }
    
    private func setupEditMode(){
        if isEditMode {
            self.topBar.tripNameTextField.isHidden = false
            self.topBar.tripDateTextField.isHidden = false
            self.topBar.nameLabel.isHidden = true
            self.topBar.dateLabel.isHidden = true
            self.mapView.moveCameraOnCurrentPath(route: self.trip!)
            
            self.displayWaypointAndRoutes()
            
            for item in (self.trip?.waypoints)! {
                self.tripWaypointVC.waypoints.append(item)
            }
            self.tripWaypointVC.displayInitialPoint()
            self.tripWaypointVC.tripId = (self.trip?.tripId)!
        }
        else{
            self.topBar.tripNameTextField.isHidden = true
            self.topBar.tripDateTextField.isHidden = true
            self.topBar.nameLabel.isHidden = false
            self.topBar.dateLabel.isHidden = false
        }
        tripWaypointVC.groupId = self.trip?.groupId ?? 0
    }
    
    /**
     * @method showCurrentLocationOnMapAndFtechRoutes
     * @discussion show current location on the Map and start Fteching Routes.
     */
    private func showCurrentLocationOnMap(){
        LocationManager.sharedManager.currentLocation(complitionHandler: {(location, error) in
            guard let _ = error else{
                self.mapView.moveMapToUserlocation(location!)
                return
            }
        })
    }
    
    private func bringSearchView(){
        self.add(asChildViewController: searchViewController)
        searchViewController.view.frame.origin.y = 155.0
        searchViewController.view.roundCorner([.topLeft, .topRight], radius: 12)

        self.view.bringSubview(toFront: searchViewController.view)
        searchViewController.view.isHidden = true
    }
    
    private func removeUnSavedWaypoints(){
        self.trip?.waypoints.removeAll()
        for waypoint in self.tripWaypointVC.waypoints {
            self.trip?.waypoints.append(waypoint)
        }
    }

    //MARK: Validate textfields
    private func validateTextFields() -> Bool{
        if isEditMode {
            if self.topBar.tripNameTextField.isEmpty() {
                AppToast.showErrorMessage(message:addTripNameMessage)
                return false
            }
            else if self.topBar.tripDateTextField.isEmpty() {
                AppToast.showErrorMessage(message: addTripDateMessage)
                return false
            }
        }
        return true
    }
    
    //MARK: IBActions
    @IBAction func locationTapped(_ sender: Any) {
        showCurrentLocationOnMap()
    }

    @objc func openCloseWaypointViewTap(sender: UIButton){
        self.isOpenWaypointView = !self.isOpenWaypointView
        self.topBar.searchButton.isEnabled = !self.isOpenWaypointView
        
        let y: CGFloat = Devices.deviceName() == Model.iPhoneX.rawValue ? (75 - 30) : 75
        let yh: CGFloat = Devices.deviceName() == Model.iPhoneX.rawValue ? (Global.screenRect.size.height - 155) - 30 : Global.screenRect.size.height - 155
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tripWaypointVC.view.frame.origin.y = self.isOpenWaypointView ? y : yh
        }) { finish in
            self.perform(#selector(AddWaypointToTripViewController.checkAndShowCardTip), with: nil, afterDelay: 0.2)
        }
    }
    
    @objc func finishRouteTapped(sender: UIButton){
        if self.validateTextFields() {
            self.assignEditData()
            AppLoader.showLoader()
            if self.trip?.drivingMode == TripType.Road.rawValue{
                self.verifyPathOnGoogle()
            }
            else{
                self.addRouteAPI()
            }
        }
    }
    
    private func assignEditData(){
        if self.isEditMode {
            self.trip?.name = self.topBar.tripNameTextField.text!
            self.trip?.createdAt = self.topBar.utcDateString
        }
    }
    
    private func verifyPathOnGoogle(){
        APIDataSource.fetchRoutePolylineFrom((self.trip?.waypoints.first?.coordinates())!, destination: (self.trip?.waypoints.last?.coordinates())!, waypoints: self.trip?.waypointsCoordinates()) { (googlePath) in
            if let gPath = googlePath {
                self.trip?.distance = gPath.distance.toMiles()
                self.trip?.totalTime = gPath.duration.toTime()
                self.trip?.polylineString = gPath.polyline
                self.addRouteAPI()
            }
            else{
                AppLoader.hideLoader()
                AppToast.showErrorMessage(message: roadRouteNotFoundMessage)
            }
        }
    }
    
    private func addRouteAPI(){
        self.trip?.groupId = self.tripWaypointVC.selectedGroup?.groupId ?? 0
        self.trip?.saveTrip(handler: { (trip, errorMessage) in
            AppLoader.hideLoader()
            if errorMessage == nil {
                if self.isEditMode {
                    self.originalTrip?.copyObject(fromRoute: trip!)
                    self.originalTrip?.polylineString = self.trip?.polylineString
                    self.dismiss(animated: true, completion: nil)
                    AppNotificationCenter.post(notification: AppNotification.updateTrip, withObject: nil)
                }
                else{
                    AnalyticsManager.addTrip(trip: trip!)
                    self.showTripAddedSuccessPopup()
                }
            }
            else{
                AppToast.showErrorMessage(message: errorMessage!)
            }
        })
    }
    
    private func showTripAddedSuccessPopup(){
        let popup = TripAddPopup(handler: { action in
            switch action {
            case .gotoMyTrip:
                self.openMyTrip()
            case .addNewTrip:
                self.openAddNewTrip()
            case .share:
                self.trip?.share()
            }
        })
        popup.displayView(onView: self.view)
        self.perform(#selector(AddWaypointToTripViewController.showAdd), with: nil, afterDelay: 0.5)
    }
    @objc private func showAdd() {
         AdMobVideoManager.shared.presentVideoAd()
    }
    private func openMyTrip(){
        self.dismiss(animated: true) { 
            AppNotificationCenter.post(notification: AppNotification.gotoMyTrip, withObject: nil)
        }
    }
    
    private func openAddNewTrip(){
        self.dismiss(animated: true) { 
            Utils.mainQueue {
                UIApplication.topViewController()?.presentAddTripController()
            }
        }
    }
    
    @objc func saveWaypointTap(sender: UIButton){
        if let _ = tripWaypointVC.selectWaypoint {
            self.displayWaypointAndRoutes()
            let points = tripWaypointVC.waypoints
            tripWaypointVC.selectWaypoint?.isTemp = false
            points.append(tripWaypointVC.selectWaypoint!)
            self.tripWaypointVC.saveWaypoint(waypoints: points)
             clearCurrentMarker()
            if points.count == 1 {
                self.showTip(popType: .waypointSearch)
            }
            else if points.count == 2{
                self.showTip(popType: .viewSavedPoints)
            }
        }
    }
    
    func displayWaypointAndRoutes(){
        if self.trip!.waypoints.count >= 2{
            self.drawRoute(self.trip!)
        }
        else if self.trip!.waypoints.count == 1 {
           // self.mapView.clear()
            if let marker = endPointMarker {
                marker.map = nil
            }
            let waypoint = self.trip!.waypoints.first
            endPointMarker = self.dropMarkerOn(CLLocationCoordinate2D(latitude: Double(waypoint!.latitude)!, longitude: Double(waypoint!.longitude)!), waypoint: waypoint!, isDraggable: false)
        }
        else{
            self.mapView.clear()
        }
    }
    
    @objc func closeButtonTapped(_ sender: Any?){
        if self.topBar.isExpand{
            topBar.searchField.text = ""
            topBar.searchButtonTapped(sender)
        }else{
            topBar.closeButton.isEnabled = false
            self.perform(#selector(AddWaypointToTripViewController.enableCloseButton), with: nil, afterDelay: 0.5)
            let alert = AddRoutesAlertPopupView(cancelTripWarning, actionButtonTitle: removeTitle) { buttonIndex in
                if buttonIndex == 2{
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alert.displayView(onView: windowGlobal != nil ? windowGlobal! : self.view)
           
        }
    }
    @objc func enableCloseButton(){
        topBar.closeButton.isEnabled = true
    }
    private func addWaypointView(){
        self.add(asChildViewController: tripWaypointVC)
        self.view.bringSubview(toFront: tripWaypointVC.view)
        self.addShadowAndBorderOnWaypointView()
    }
    
    //MARK: Private Methods
    private func addShadowAndBorderOnWaypointView(){
        tripWaypointVC.delegate = self
        let yPoint = Global.screenRect.size.height - 155
        let height = Global.screenRect.size.height - 75
        let y = Devices.deviceName() == Model.iPhoneX.rawValue ? yPoint - 30 : yPoint
        tripWaypointVC.view.frame.origin.y = y
        tripWaypointVC.view.frame.size.height = Devices.deviceName() == Model.iPhoneX.rawValue ? (height - 30) : height
        tripWaypointVC.headerView.roundCorner([.topLeft, .topRight], radius: 12)
        tripWaypointVC.view.layer.masksToBounds = false
        tripWaypointVC.view.layer.shadowOffset = CGSize(width: 2, height: -6)
        tripWaypointVC.view.layer.shadowRadius = 11
        tripWaypointVC.view.layer.shadowOpacity = 11
        tripWaypointVC.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.21).cgColor
        tripWaypointVC.openCloseButton.addTarget(self, action: #selector(AddWaypointToTripViewController.openCloseWaypointViewTap(sender:)), for: .touchUpInside)
        tripWaypointVC.addNewPoint.addTarget(self, action: #selector(AddWaypointToTripViewController.openCloseWaypointViewTap(sender:)), for: .touchUpInside)
        tripWaypointVC.finishRouteButton.addTarget(self, action: #selector(AddWaypointToTripViewController.finishRouteTapped(sender:)), for: .touchUpInside)
        tripWaypointVC.savePointButton.addTarget(self, action: #selector(AddWaypointToTripViewController.saveWaypointTap(sender:)), for: .touchUpInside)
    }
    
    public func showSelectedAddress(waypoint: Wayponit){
        tripWaypointVC.selectWaypoint(waypoint: waypoint)
    }
 
}
