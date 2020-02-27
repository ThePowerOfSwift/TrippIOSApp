//
//  RouteListViewController.swift
//  
//
//  Created by Bharat Lal on 11/07/17.
//
//

import UIKit
import NRControls
import CoreLocation
import GoogleMobileAds

class RouteListViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var routesListtableview: UITableView!
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var tripsCountLabel: CharacterSpaceLabel!
    
    var routesList: [Route] = []
    var currentPage = 1
    var perPageItmes = 5
    var totalPage = 0
    var userLocation: CLLocation?
    var routeCounter = 0
    var isFilterApplied = false
    var filters = ""
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMobManager.loadBanner(self.bannerView, rootViewController: self)
        addNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupview()
        AdMobManager.checkAndUpdateBanner(self.bannerView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Private
    private func setupview(){
        routesListtableview.register(RouteTableViewCell.nib, forCellReuseIdentifier: RouteTableViewCell.identifier)
        routesListtableview.register(AdMobBannerCell.nib, forCellReuseIdentifier: AdMobBannerCell.cellIdentifier)
        if let parentVC = self.parent as? RoutesBaseViewController, let topView = parentVC.topView{
            if topView.selectedTab == .Routes{
                self.setupRoutesList()
                parentVC.view.backgroundColor = UIColor.myTripBackgroundColor()
                topView.backgroundColor = UIColor.myTripBackgroundColor()
            }
        }
    }
    
    private func addNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.tripDeleted(_:)), name: AppNotification.deleteMyTrip, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.tripWishDeleted(_:)), name: AppNotification.deleteRouteWish, object: nil)
    }
    func setupRoutesList(){
        if self.routesList.count == 0 {
            self.fetchRoutesNearByUserLocation()
            self.updateRouteInfo(isFetching: true)
        } else if isFilterApplied {
            applyFilter()
        }else{
            self.updateRouteInfo(isFetching: false)
        }
    }
    func tripWishDeleted(_ notification: Notification){
        if let deletedWish = notification.userInfo?["tripWish"] as? Route {
            let objects = routesList.filter({$0.tripId == deletedWish.tripId})
            if objects.count > 0{
                objects.first?.isMyWish = false
            }
        }
    }
    func tripDeleted(_ notification: Notification){
        if let deletedRoute = notification.userInfo?["trip"] as? Route, deletedRoute.isAddedFromRoute != 0 {
            let objects = routesList.filter({$0.tripId == deletedRoute.isAddedFromRoute}) // isAddedFromRoute is key for route id
            if objects.count > 0{
                objects.first?.isMyTrip = false
            }
        }
    }
    func fetchRoutes(nearBy location: CLLocation){
        APIDataSource.fetchRoutes(.fetchRoutes(page: currentPage, lat: String(location.coordinate.latitude), lon: String(location.coordinate.longitude), filter: self.filters)) { (routes, totalPage, perPageCount, error) in
            if let _ = error {
                return
            }
            guard let moreRoutes = routes else {
                return
            }
            
            if AppUser.currentUser().subscription() == .subscribed {
                self.routesList.append(contentsOf: moreRoutes)
            } else {
                for object in moreRoutes {
                    let totalAddCount = (self.routesList.count / 5) - 1
                    if (self.routesList.count == 5) || (self.routesList.count > 5 && (self.routesList.count - totalAddCount) % 5 == 0) {
                        let adRoute = Route()
                        adRoute.role = UserRole.AdMob.rawValue
                        self.routesList.append(adRoute)
                    }
                    
                    self.routesList.append(object)
                }
            }
            
            self.perPageItmes = perPageCount!
            self.routesListtableview.reloadData()
            self.routeCounter = self.routesList.filter({$0.role != UserRole.AdMob.rawValue}).count
            self.updateRouteInfo()
            
            self.totalPage = totalPage!
        }
    }
    func fetchRoutesInState(_ state: State){
        currentPage = 0
        self.filters = ""
        self.routesList.removeAll()
        self.routesListtableview.reloadData()
        self.updateRouteInfo(isFetching: true)
        fetchRoutes(nearBy: CLLocation(latitude: Double(state.lat!)!, longitude: Double(state.lon!)!))
        
    }
    private func updateRouteInfo(isFetching: Bool = false){
        (self.parent as? RoutesBaseViewController)?.topView?.updateRouteCounterInfo(self.routeCounter, isFilter: self.isFilterApplied, isFetching: isFetching)
    }
    private func fetchRoutesNearByUserLocation(){
        
        LocationManager.sharedManager.currentLocation(complitionHandler: {(location, error) in
            guard let _ = error else{
                self.userLocation = location
                self.fetchRoutes(nearBy: location!)
                return
            }
        })
        
    }
    /**
     * @method applyFilter
     * @discussion fetch And Draw Routes on the map with filter
     */
    
    func applyFilter(){
        self.currentPage = 1
        self.routeCounter = 0
        self.updateRouteInfo(isFetching: true)
        self.routesList.removeAll()
        self.routesListtableview.reloadData()
        self.fetchRoutesNearByUserLocation()
    }
    //MARK: IBActions 
    @IBAction func filterTapped(_ sender: UIButton) {
        
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
                }else{
                    self.clearFilters()
                }
            }
        }
        
    }
    //MARK: Clear filtes
    /**
     * @method clearFilters
     * @discussion fetch And Draw Routes on the map with no filter
     */
    func clearFilters(){
        self.filters = ""
        self.isFilterApplied = false
        self.applyFilter()
    }

}
