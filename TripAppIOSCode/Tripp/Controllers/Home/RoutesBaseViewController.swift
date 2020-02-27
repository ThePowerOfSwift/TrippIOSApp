//
//  RoutesBaseViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 20/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import  CoreLocation

struct FilterBottomConstraint {
    static let map:CGFloat = 22.0
    static let list:CGFloat = 62
}


class RoutesBaseViewController: UIViewController {
    //MARK: variables
    var isFilterApplied = false
    var filters = ""
    var topView: RoutesTopView?
    var viewType = RouteViewType.map
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var mapTypeButton: UIButton!
    
    @IBOutlet weak var filterButtonConstrant: NSLayoutConstraint?
    
    lazy var routeMapViewController: HomeViewController = {
    
        
        // Instantiate View Controller
        var viewController = routesStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.home.rawValue) as! HomeViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    lazy var routeListViewController: RouteListViewController = {
        
        // Instantiate View Controller
        var viewController = routesStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.routeList.rawValue) as! RouteListViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
   fileprivate lazy var searchViewController: SearchViewController = {
        var viewController = homeStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.sarchViewController.rawValue) as! SearchViewController
        
        return viewController
    }()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateView()
        //view.backgroundColor = UIColor.myTripBackgroundColor()
        filterButton.dropShadow(opacity: 0.4, offset: CGSize(width: 0.0, height: 8.0), radius: 3.0)
    }
    override func viewDidLayoutSubviews() {
        self.topView?.makeBottomCornerRounded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.topView == nil{
             self.setupTopView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper
     func setupTopView(){
        topView = RoutesTopView.fromNib()
        topView!.addOnView(view: self.view)
        topView!.delegate = self
        topView?.selectedTab = .Routes
        topView?.updateTopViewAccordingToTab()
        self.addSearchView()
        topView?.searchTextFleid.delegate = self
        topView?.searchTextFleid.addTarget(self, action: #selector(AddWaypointToTripViewController.textFieldDidChange(_:)), for: .editingChanged)

    }
    
    func updateView() {
        if self.viewType == .map {
            remove(asChildViewController: routeListViewController)
            add(asChildViewController: routeMapViewController)
            self.filterButtonConstrant?.constant = FilterBottomConstraint.map
            
        } else {
            remove(asChildViewController: routeMapViewController)
            add(asChildViewController: routeListViewController)
            self.filterButtonConstrant?.constant = AppUser.currentUser().subscription() == .subscribed ? FilterBottomConstraint.map : FilterBottomConstraint.list
        }
    }
    private func addSearchView(){
        self.add(asChildViewController: searchViewController)
        searchViewController.view.frame.origin.y = 155.0
        searchViewController.view.roundCorner([.topLeft, .topRight], radius: 12)
        self.view.bringSubview(toFront: searchViewController.view)
        searchViewController.view.isHidden = true
        searchViewController.searchMode = .States
    }

    //MARK: ------ IBActions
    @IBAction func filterTapped(_ sender: Any) {
        self.topView?.isUserInteractionEnabled = false
        let filterView = MapFilterView.initializeFilter(selectedFilters: self.filters)
        filterView.displayView(onView: windowGlobal!) { (action, filters) in
            self.topView?.isUserInteractionEnabled = true
            if action == FilterAction.done {
                if filters.isEmpty == false{
                    self.filters = filters
                    self.isFilterApplied = true
                    self.applyFilter()
                }else if self.isFilterApplied {
                    
                    self.clearFilter()
                }
            }
        }
        
    }
    func applyFilter(){
        self.resetChildControllersFilters()
        if self.viewType == .map {
            routeMapViewController.applyFilter()
        } else {
            routeListViewController.applyFilter()
        }
    }
    func resetChildControllersFilters(){
        routeMapViewController.filters = self.filters
        routeMapViewController.isFilterApplied = self.isFilterApplied
        routeListViewController.filters = self.filters
        routeListViewController.isFilterApplied = self.isFilterApplied
        
    }

}
extension RoutesBaseViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchViewController.view.isHidden = true
        topView?.searchTextFleid.resignFirstResponder()
    }
    func textFieldDidChange(_ textField: UITextField){
        searchViewController.view.isHidden = textField.isEmpty()
        if !textField.isEmpty(){
            searchViewController.searchForState(textField.text!, callback: { state in
                self.topView?.searchTextFleid.text = ""
                self.topView?.toggleSearch(nil)
                if let lat = state.lat, let lon = state.lon, lat.isEmpty == false, lon.isEmpty == false{
                     self.stateSelected(state)
                }
               
            })
        }
    }
    func stateSelected(_ state: State){
        if self.viewType == .map {
             self.routeMapViewController.fetchRoutesInState(state)
        } else {
               routeListViewController.fetchRoutesInState(state)
            
        }
    }
}

extension RoutesBaseViewController: RouteViewTypeDelegate{
    
    func routeViewChanged(to viewType: RouteViewType) {
        self.viewType = viewType
        self.updateView()
    }
    func clearFilter() {
        self.filters = ""
        self.isFilterApplied = false
        routeMapViewController.shouldClearFilters = true
        routeListViewController.routesList.removeAll()
        self.resetChildControllersFilters()
        if self.viewType == .map {
            routeMapViewController.clearFilters()
        } else {
            routeListViewController.clearFilters()
        }
    }
}
