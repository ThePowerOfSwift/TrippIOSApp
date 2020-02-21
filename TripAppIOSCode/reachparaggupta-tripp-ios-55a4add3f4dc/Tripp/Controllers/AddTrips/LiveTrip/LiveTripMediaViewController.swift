//
//  LiveTripMediaViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 18/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import RealmSwift

class LiveTripMediaViewController: TripMediaBaseViewController {
    //MARK: IBOutlet / variable
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var recordLabel: CharacterSpaceLabel!
    @IBOutlet weak var finishButton: RoundedBorderButton!
    @IBOutlet weak var deleteButton: RoundedBorderButton!
    @IBOutlet weak var mediaLabel: CharacterSpaceLabel!
    @IBOutlet weak var addMediaButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editModeOpenIndicatorView: UIView!
    @IBOutlet weak var editCategoryButton: UIButton!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var addToMyTripButton: RoundedBorderButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    var isOpen = false
    var startLocation: CLLocation?
    var currentLocation: CLLocation?
    var startAddress = unableToFindAddress
    var currentAddress = unableToFindAddress
    var parentController:AddLiveTripViewController!
    var isExpandMedia = false
    var isEditMode = false
    var mediaIndexToBeDeleted = -1
    
    //MARK: local file messages
    let pleaseWaitForLocation = "Please wait, we are fetching your locations..."
    let pleaseStartTrip = "Please start your trip"
    
    var categories = [Category]()
    var categoryNameStrings: [String] = []
     var selectedCategory: Category?
    var selectedGroup: Group?
    var groups = [Group]()
    
     //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parentController = self.parent as! AddLiveTripViewController
        setupView()
        setupGroupTextField()
        fetchGroups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addToMyTripButton.isHidden = self.parentController.trip?.isMyTrip == true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func saveNewAssets(asset: MediaAsset, index: Int) {
        do{
            let realm = try Realm()
            try realm.write({ 
                super.saveNewAssets(asset: asset, index: index)
            })
            
        }catch{
            // error
        }
        
        self.reloadTable()
    }
    
    @IBAction func editGroupTapped(_ sender: Any) {
        groupNameTextField.becomeFirstResponder()
    }
    
    private func fetchGroups(){
        AppLoader.showLoader()
        APIDataSource.groupListing(service: .groupList(page: 1)) { [weak self] (groups, paging, message) in
            AppLoader.hideLoader()
            if let groupsResponse = groups{
                self?.groups = groupsResponse
                self?.setupGroupTextField()
                if let groupId = self?.parentController.trip?.groupId, groupId > 0 {
                    self?.selectedGroup = self?.groups.filter({$0.groupId == groupId}).first
                    self?.groupNameTextField.text = self?.selectedGroup?.name
                }
            }
        }
    }
    
    private func setupGroupTextField() {
        let groupNames = self.groups.compactMap({$0.name})
        self.groupNameTextField.inputView = CustomPickerView(pickerComponent: [groupNames], completion: { (_, indexPath) in
            guard let index = indexPath?.row else { return }
            self.groupNameTextField.text = groupNames[index]
            self.selectedGroup = self.groups[index]
        })
    }
    
    //MARK: IBAction
    @IBAction func finishtapped(_ sender: Any) {

         if self.parentController.trackingManager.currentLocation == nil {
            
                    if !Connection.isInternetConnected() {
                        return
                    }
            
            AppToast.showErrorMessage(message: pleaseWaitForLocation)
            return
        }
        
        if isEditMode {
            
            if !Connection.isInternetConnected() {
                return
            }

            self.parentController.editTripAPI()
        }
        else{
            let alert = AddRoutesAlertPopupView(saveTripMessge, saveTripQuestion, actionButtonTitle: closeTitle) { buttonIndex in
                if buttonIndex == 2{
                    AppLoader.showLoader()
                    LocationManager.sharedManager.stopFetchingLocation()
                    self.stopTrip()
                }
            }
            alert.displayView(onView: windowGlobal != nil ? windowGlobal! : self.view)
        }
    }
    private func saveOffline() {
        self.parentController.updateStartEndCoordinateAndCalculateDistance()
        self.parentController.trackingManager.finishTracking{ (fileName) in
            self.parentController.showTripAddedSuccessPopup()
        }
        
    }
    private func internetError() {
        AppToast.showSuccessMessage(message: "It seems your internet connection is not working properly. The Trip has been saved locally, and will be synced with server once your device get proper internet connection.")
    }
    fileprivate func handleInternetError() {
        self.parentController.updateStartEndCoordinateAndCalculateDistance()
        if let trip =  self.parentController.trip {
            OfflineRoute.offlineRouteFrom(trip: trip)
        }
        self.parentController.showTripAddedSuccessPopup()
        self.internetError()
    }
    
    private func stopTrip(){
        if !Connection.isInternetConnected() {
            saveOffline()
            AppLoader.hideLoader()
       } else{
            geoCodingAddress(coordinate: (parentController.trackingManager.currentLocation?.location)!, complition: { success in
                if success{
                    AppLoader.showLoader()
                    self.parentController.updateStartEndCoordinateAndCalculateDistance()
                    self.parentController.trackingManager.finishTracking { (fileName) in
                        if let name = fileName {
                            self.parentController.saveTripAPI(name)
                        }
                        else{
                            AppLoader.hideLoader()
                            self.handleInternetError()
                        }
                    }
                }else{
                    AppLoader.hideLoader()
                    self.handleInternetError()
                }
            })
        }
        
    }
    
    @IBAction func addToMyTrippButtonTapped(_ sender: Any) {
        AppLoader.showLoader()
        self.parentController.trip?.addToMyTrip(categoryId: "", handler: { [weak self] (message, error) in
            AppLoader.hideLoader()
            if isGuardObject(message) {
                AppToast.showSuccessMessage(message: message!)
                self?.addToMyTripButton.isHidden = true
            }
            else {
                AppToast.showErrorMessage(message: error!)
            }
        })
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let alert = AddRoutesAlertPopupView(cancelTripWarning, actionButtonTitle: continueTitle) { buttonIndex in
            if buttonIndex == 2{
                self.deleteTrip()
            }
        }
        alert.displayView(onView: windowGlobal != nil ? windowGlobal! : self.view)
        
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        LocationManager.sharedManager.checkLiveTrackingPermission { (status) in
            if status == .authorizedAlways{
                if !self.parentController.trackingManager.isStarted {
                    LiveTrackingManager.sharedManager.writeToFile("---------------- Start Recording ---------------")
                    self.startRecording()
                }else{
                    self.finishtapped(sender)
                }
            }
            else{
                AppToast.showErrorMessage(message: permissionNotFoundMessage)
            }
        }
    }
    @IBAction func editCategoryTapped(_ sender: Any) {
        if let parentController = self.parent as? AddWaypointToTripViewController, parentController.trip?.categoryId.value == nil {
            loadAndShowCategories()
        }else{
            self.openActionSheet()
        }
        
    }
    func loadAndShowCategories(){
        AppLoader.showLoader()
        CategoryManager.sharedManager.fetchCategories { (categories, error) in
            AppLoader.hideLoader()
            if let categoriesArray = categories{
                self.categories = categoriesArray
                self.categoryNameStrings = self.categories.map( { $0.name })
                Utils.mainQueue {
                    self.perform(#selector(LiveTripMediaViewController.showCategoryPicker), with: nil, afterDelay: 0.1)
                }
                
            }
        }
    }
    @objc internal func showCategoryPicker(){
        
        categoryTextField.inputView = CustomPickerView(pickerComponent: [categoryNameStrings], completion: { (picker, indexPath) in
            
            self.selectedCategory = self.categories[(indexPath?.item)!]
            self.categoryTextField.text = self.selectedCategory!.name
            if let parentController = self.parent as? AddLiveTripViewController{
                parentController.trip?.updateCategory(self.selectedCategory?.categoryId)
            }
        
        })
        self.categoryTextField.becomeFirstResponder()
    }
    //-- Open location alert action
    func openActionSheet(){
        let actionController = UIAlertController(title: nil, message: chooseOption, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        
        let editAction = UIAlertAction(title: editCategory, style: .default) { (camera) -> Void in
            self.loadAndShowCategories()
        }
        
        let deleteAction = UIAlertAction(title: deleteCategory, style: .destructive) { (camera) -> Void in
            if let parentController = self.parent as? AddWaypointToTripViewController{
               // parentController.trip?.categoryId.value = nil
                parentController.trip?.updateCategory(nil)
                self.categoryTextField.text = noCategory
            }
        }
        actionController.addAction(editAction)
        actionController.addAction(deleteAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    func startRecording(){
        self.parentController.trackingManager.isStarted = true
        self.recordLabel.isHidden = true
        self.toggleAddMediaButton(hide: false)
        self.parentController.startContinueFetchLocation()
        self.recordButton.setImage(UIImage(named: "stopTrip"), for: .normal)
        LocationManager.sharedManager.lastLocation = nil
    }
    
    @IBAction func openOrCloseViewTapped(_ sender: UIButton?){
        if !isEditMode && !self.parentController.trackingManager.isStarted {
            AppToast.showErrorMessage(message: pleaseStartTrip)
            return
        }
        else if self.parentController.trackingManager.currentLocation == nil {
            AppToast.showErrorMessage(message: pleaseWaitForLocation)
            return
        }
        if parentController.fromGroups == true {
            editCategoryButton.isHidden = true
        }
        
        self.isOpen = !self.isOpen
        self.waypoints = (self.parentController.trip?.waypoints)!
        parentController.closeButton.isEnabled = !self.isOpen
        if isOpen{
            categoryView.isHidden = false
            parentController.view.sendSubview(toBack: parentController.locationButton)
            addressFromGeocodeCoordinate(coordinate: (parentController.trackingManager.startLocation?.location)!, isStartLocation: true)
            addressFromGeocodeCoordinate(coordinate: (parentController.trackingManager.currentLocation?.location)!, isStartLocation: false)
        } else {
            categoryView.isHidden = true
        }
        animateView()
    }
    
    //MARK: Private / helper
    private func deleteTrip(){
        AppLoader.showLoader()
        parentController.trip?.deleteTrip(handler: { (message, error) in
            AppLoader.hideLoader()
            if error == nil {
                AppToast.showSuccessMessage(message: message!)
                AppNotificationCenter.post(notification: AppNotification.deleteMyTrip, withObject: ["trip": self.parentController.trip!])
                self.parentController.closeButtonTapped(nil)
            }
            else{
                AppToast.showErrorMessage(message: error!)
            }
        })
    }
    private func toggleAddMediaButton(hide: Bool){
        if !isEditMode{
            addMediaButton.isHidden = hide
            mediaLabel.isHidden = hide
        }
    }
    private func animateView(){
        let y: CGFloat = Devices.deviceName() == Model.iPhoneX.rawValue ? 40 : 20
        let yh: CGFloat = Devices.deviceName() == Model.iPhoneX.rawValue ? (Global.screenRect.size.height - 161) - 60 : Global.screenRect.size.height - 161
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.isOpen ? y : yh
        }) { finish in
            if !self.isEditMode{
                if !self.isOpen{
                    self.finishButton.isHidden = true
                    self.toggleAddMediaButton(hide: false)
                    self.parentController.view.bringSubview(toFront: self.parentController.locationButton)
                }else{
                    self.finishButton.isHidden = false
                    self.toggleAddMediaButton(hide: true)
                }
                self.perform(#selector(LiveTripMediaViewController.reloadTable), with: nil, afterDelay: 0.3)
            }
            
        }
    }
    private func setupView(){
        self.finishButton.addCharacterSpace(space: -0.3)
        self.finishButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 17.6)
        self.deleteButton.addCharacterSpace(space: -0.3)
        self.deleteButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 17.6)
        toggleAddMediaButton(hide: !self.parentController.trackingManager.isStarted)
        recordLabel.isHidden = self.parentController.trackingManager.isStarted
        finishButton.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        deleteButton.isHidden = true
        self.editModeOpenIndicatorView.isHidden = !isEditMode
        if let parentController = self.parent as? AddLiveTripViewController{
            parentController.trip?.categoryName(handler: { categoryName in
                self.categoryTextField.text = categoryName
            })
        }
        if isEditMode{
            setupViewForEditMode()
        }
    }
    private func setupViewForEditMode(){
        recordLabel.isHidden = true
        recordButton.isHidden = true
        finishButton.setAttributedTitle(NSAttributedString(string: "SAVE"), for: .normal)
        finishButton.isHidden = false
        addMediaButton.isHidden = true
        mediaLabel.isHidden = true
        deleteButton.isHidden = false
    }
    @objc func reloadTable(){
        tableView.reloadData()
    }
    // will be called for start and current locations
    func addressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D, isStartLocation: Bool) {
        APIDataSource.waypointFromCoordinate(coordinate: coordinate, drivingMode: (self.parentController.trip?.drivingMode)!) { (waypoint) in
            if let point = waypoint {
                self.updateAddressInfo(point.address, isStart: isStartLocation, waypoint: point)
            }
            else{
                self.currentAddress = unableToFindAddress
                self.reloadTable()
            }
        }
    }
    // will be called on stop trip
    private func geoCodingAddress(coordinate: CLLocationCoordinate2D, complition: @escaping (_ success: Bool)->()){
        AppLoader.showLoader()
        APIDataSource.waypointFromCoordinate(coordinate: coordinate, drivingMode: (self.parentController.trip?.drivingMode)!) { (waypoint) in
            AppLoader.hideLoader()
            if let point = waypoint {
                 self.parentController.trip?.waypoints.last?.updateLiveTripCurrentPoint(point: point)
                complition(true)
            }else{
                complition(false)
            }
        }
    }
    private func updateAddressInfo(_ address: String, isStart: Bool, waypoint:Wayponit){
        if isStart{
            startAddress = address
            self.parentController.trip?.waypoints.first?.updateLiveTripCurrentPoint(point: waypoint)
        }else{
            currentAddress = address
            self.assetMediaAddress.address = address
            self.parentController.trip?.waypoints.last?.updateLiveTripCurrentPoint(point: waypoint)
            self.updateAssetsMediaAddress(point: waypoint)
        }
        
        reloadTable()
    }
    
    private func updateAssetsMediaAddress(point: Wayponit){
        //-- Append current lat long
        if let endLocation = self.parentController.trackingManager.currentLocation {
            self.assetMediaAddress.latitude = endLocation.lat
            self.assetMediaAddress.longitude = endLocation.lon
        }
        self.assetMediaAddress.address = point.address
        self.assetMediaAddress.city = point.city
        self.assetMediaAddress.state = point.state
        self.assetMediaAddress.country = point.country
    }
}
