//
//  MyTripsViewController.swift
//  Tripp
//
//  Created by Monu on 20/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class MyTripsViewController: RoutesBaseViewController {
    
    var myTripList: [Route] = []
    var wishes: [Route] = []
    var locationWishes: [LocationWish] = []
    var placeWishes: [Place] = []
    var tripManager: TripsManager?
    var wishManager: WishRoutesManager?
    var isLiveTripFilter: Bool? = nil
    var categoriesFilters: String? = nil
    var drivingModeFilters: String? = nil
    var showingWish: Bool = true
    var groupMember: GroupMember?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.fetchAndDrawMyTrips()
        self.addNotification()
        if let isLiveTrcking = AppUserDefaults.value(for: .livetrackingOn) as? Bool, isLiveTrcking == true {
            presentLiveTripController()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTripView()
        fetchAndDrawMyTrips()
        if groupMember == nil {
            addCreateTripButton()
            loadWishesIfRequired()
        } else {
            addCloseButton()
            topView?.saveTripslabel.text = (groupMember?.fullName ?? "User") + "'s Trips"
            tabBarController?.tabBar.isHidden = true
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tripManager?.cancelAllOperations()
        reloadTripListView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Helper
    private func loadWishesIfRequired() {
        if showingWish {
            fetchAndDrawWishes()
            fetchAndShowlocationWishes()
            fetchAndShowPlacesWishes()
        }
    }
    private func addCreateTripButton() {
        let btn = getButtonWith(#imageLiteral(resourceName: "icAddANewTrip"))
        btn.frame.origin.y = 34.0
        btn.addTarget(self, action: #selector(MyTripsViewController.createTrip), for: .touchUpInside)
    }
    private func addCloseButton() {
        let closeButton = getButtonWith(#imageLiteral(resourceName: "closeIcon"))
        closeButton.addTarget(self, action: #selector(MyTripsViewController.close), for: .touchUpInside)
    }
    private func getButtonWith(_ image: UIImage) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: .normal)
        btn.backgroundColor = .clear
        btn.frame = CGRect(x: view.frame.size.width - 50, y: 28, width: 40, height: 40)
        view.addSubview(btn)
        return btn
    }
    @objc private func close() {
        popViewController()
    }
    @objc private func createTrip() {
        let vc = addTripsStoryBoard().instantiateInitialViewController()
        let nav = UINavigationController(rootViewController: vc!)
        self.present(nav, animated: true, completion: nil)
//        self.navigationController?.present(vc!, animated: true, completion: nil)s
    }
    private func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(MyTripsViewController.updateTrip(_:)), name: AppNotification.updateTrip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyTripsViewController.deleteTrip(_:)), name: AppNotification.deleteMyTrip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyTripsViewController.deleteLocationWish(_:)), name: AppNotification.deleteLocationWish, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyTripsViewController.deleteRouteWish), name: AppNotification.deleteRouteWish, object: nil)
    }
    
    @objc func updateTrip(_ notification: Notification){
        refresh()
    }
    
    @objc func deleteTrip(_ notification: Notification){
        if let deletedRoute = notification.userInfo?["trip"] as? Route {
            let objects = self.myTripList.filter({$0.tripId == deletedRoute.tripId})
            if objects.count > 0{
                self.myTripList.removeObject(obj: objects.first!)
            }
            refresh()
        }
    }
    @objc func deleteLocationWish(_ notification: Notification) {
        if let deletedWish = notification.userInfo?["locationWish"] as? LocationWish {
            let objects = self.locationWishes.filter({$0.locationWishlistId == deletedWish.locationWishlistId})
            if objects.count > 0{
                self.locationWishes.removeObject(obj: objects.first!)
            }
            refresh()
        }
    }
    @objc func deleteRouteWish(_ notification: Notification) {
        if let deletedRoute = notification.userInfo?["tripWish"] as? Route {
            let objects = self.wishes.filter({$0.tripId == deletedRoute.tripId})
            if objects.count > 0{
                self.wishes.removeObject(obj: objects.first!)
            }
            refresh()
        }
    }
    private func refresh() {
        self.updateView()
        self.refreshMap()
    }
    private func refreshMap(){
        self.routeMapViewController.mapView.clear()
        for trip in self.myTripList {
            self.routeMapViewController.drawRoute(route: trip)
        }
        for wish in self.wishes {
             self.routeMapViewController.drawRoute(route: wish)
        }
        self.routeMapViewController.showLocationWishes(self.locationWishes)

    }
    
    override func setupTopView(){
        super.setupTopView()
        topView?.selectedTab = .MyTrips
        topView?.updateTopViewAccordingToTab()
        
    }
    func setupTripView(){
        
        self.routeListViewController.routesListtableview.backgroundColor = UIColor.myTripBackgroundColor()
        self.routeListViewController.tableViewTop.constant = 188.5
        self.routeListViewController.welcomeView.isHidden = false
        self.topView?.searchIcon.isHidden = true
    }
    
    override func updateView() {
        super.updateView()
        if self.viewType == .list {
            reloadTripListView()
        }
    }
    
    /**
     * @method fetchAndDrawMyTrips
     * @discussion fetch And Draw Tripps on the map
     */
    func fetchAndDrawMyTrips(){
        tripManager = TripsManager()
        tripManager?.startFetchingTripps(drivingMode: drivingModeFilters, isLive: isLiveTripFilter, categoryId: categoriesFilters, userId: groupMember?.groupUserId.value, { (route, error) in
            guard let aRoute = route else{
                return
            }
            
            let search = self.myTripList.filter({$0.tripId == route?.tripId})
            if search.count <= 0{
                Utils.mainQueue {
                    if AppUser.currentUser().subscription() != .subscribed {
                        let totalAddCount = (self.myTripList.count / 5) - 1
                        if (self.myTripList.count == 5) || (self.myTripList.count > 5 && (self.myTripList.count - totalAddCount) % 5 == 0) {
                            let adRoute = Route()
                            adRoute.role = UserRole.AdMob.rawValue
                            self.myTripList.append(adRoute)
                        }
                    }
                    aRoute.isMyTrip = true
                    self.myTripList.append(aRoute)
                    self.routeMapViewController.drawRoute(route: aRoute)
                    self.updateMyTripList()
                }
            }
            
        })
    }
    //MARK: - Wish list
    private func fetchAndDrawWishes() {
        wishManager = WishRoutesManager()
        wishManager?.startFetchingWishes({ (route, error) in
            guard let aRoute = route else{
                return
            }
            let search = self.wishes.filter({$0.tripId == route?.tripId})
            if search.count <= 0{
                Utils.mainQueue {
                    self.wishes.append(aRoute)
                    self.routeMapViewController.drawRoute(route: aRoute)
                }
            }
        })
    }
    private func fetchAndShowPlacesWishes(){
        APIDataSource.fetchPlacesWishOrCompletedList(service: .placeWishList()) { [weak self] (places, error) in
            guard let list = places else{
                return
            }
            self?.placeWishes = list
            self?.routeMapViewController.showPlaceWishes((self?.placeWishes)!)
        }
    }
    private func fetchAndShowlocationWishes(){
        APIDataSource.userLocationWishList(service: .locationWishList) { (wishList, error) in
            guard let list = wishList else{
                return
            }
            self.locationWishes = list
            self.routeMapViewController.showLocationWishes(self.locationWishes)
        }
    }
    
    func updateMyTripList(){
        if self.viewType == .list {
            reloadTripListView()
        }
    }
    func reloadTripListView(){
        self.routeListViewController.routesList = self.myTripList
        self.routeListViewController.routesListtableview.reloadData()
        self.routeListViewController.tripsCountLabel.text = "\(self.myTripList.filter({$0.role != UserRole.AdMob.rawValue}).count) " + tripCountMessage
    }
    //MARK: IBActions
    @IBAction override func filterTapped(_ sender: Any) {
        AppLoader.showLoader()
        CategoryManager.sharedManager.fetchCategories { (categories, error) in
            AppLoader.hideLoader()
            self.topView?.isUserInteractionEnabled = false
            let filterView = MapFilterView.initializeFilter(selectedModes: self.drivingModeFilters ?? "", selectedCategoryIds: self.categoriesFilters ?? "", isLiveTripSelected: self.isLiveTripFilter ?? nil, avaibalbeCategories: categories, isWish: self.showingWish)
            
            filterView.displayTripFilterView(onView: windowGlobal ?? self.view) { (action, categoryIds, isWishFilterOn) in
                
                self.topView?.isUserInteractionEnabled = true
                if action == FilterAction.done {
                    self.showingWish = isWishFilterOn
                    if isWishFilterOn == false {
                        self.wishes.removeAll()
                        self.locationWishes.removeAll()
                        self.clearFilter()
                    }else {
                        self.loadWishesIfRequired()
                    }
                    if categoryIds.isEmpty == false {
                        self.categoriesFilters = categoryIds
                        self.isFilterApplied = true
                        self.applyFilter()
                    }else if self.isFilterApplied {
                        self.clearFilter()
                    }
                }
            }
        }
    }
    override func applyFilter(){
        tripManager?.cancelAllOperations()
        tripManager = nil
        myTripList.removeAll()
        refreshMap()
        reloadTripListView()
        fetchAndDrawMyTrips()
        loadWishesIfRequired()
    }
    override func clearFilter() {
        isLiveTripFilter = nil
        categoriesFilters = nil
        drivingModeFilters = nil
        isFilterApplied = false
        myTripList.removeAll()
        applyFilter()
    }
    //MARK: deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
