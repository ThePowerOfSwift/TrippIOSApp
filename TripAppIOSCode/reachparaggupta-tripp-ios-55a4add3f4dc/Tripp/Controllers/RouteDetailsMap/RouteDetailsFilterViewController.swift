//
//  RouteDetailsFilterViewController.swift
//  Tripp
//
//  Created by Monu on 10/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class RouteDetailsFilterViewController: BaseViewController {
    
    var filterView = RouteFilterView.initializeFilter()
    
    var placeFinderManager = PlaceFinderManager()
    
    //MAEK: UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.googleMapView?.addMapTypeToggleButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkAndDrawRoute()
    }
    
    //MARK: Private methods
    private func setupView(){
        addChildView()
        addTargets()
        addFilterHandler()
        displayInformation()
    }
    
    //-- Add sub view or childs
    private func addChildView(){
        topBar = RouteDetailsTopBar.initializeTopBar()
        self.view.addSubview(self.topBar!)
        self.view.addSubview(self.filterView)
    }
    
    private func addTargets(){
        self.topBar?.backButton.addTarget(self, action: #selector(RouteDetailsFilterViewController.popViewController), for: .touchUpInside)
        self.topBar?.addToWishListButton.addTarget(self, action: #selector(RouteDetailsFilterViewController.wishlistButtonTapped(sender:)), for: .touchUpInside)
        self.topBar?.shareButton.addTarget(self, action: #selector(RouteDetailsFilterViewController.shareButtonTapped(sender:)), for: .touchUpInside)
    }
    
    private func addFilterHandler(){
        self.filterView.handler = {(action, filters) in
            if action == .done || action == .clear {
                self.googleMapView?.clear()
                self.checkAndDrawRoute()
                if !filters.isEmpty {
                    self.applyFilter(withType: filters)
                }
            }
        }
    }
    
    private func displayInformation(){
        if let selectedRoute = self.route{
            self.topBar?.titleLabel.text = selectedRoute.name
            self.topBar?.subTitleLabel.text = selectedRoute.stateName
            if selectedRoute.isMyWish == true{
                topBar?.addToWishListButton.isEnabled = false
            }
        }
    }
    
    //MARK: Fetch Places and draw marker
    func applyFilter(withType:String){

        self.placeFinderManager.fetchingPlaces(onRoute: route!, place: withType) { (places, error) in
            if places != nil {
                Utils.mainQueue {
                    for place in places!{
                        let marker = self.placeMarker(latitude: place.latitude!, longitude: place.longitude!, image: place.marker(searchPlace: withType))
                        marker.map = self.googleMapView
                    }
                }
            }
        }

    }
    
    func fetchPlaces(params: [String:Any]){
        APIDataSource.fetchPlaces(params: params) { (places, nextPageToken, error) in
            if places != nil {
                Utils.mainQueue {
                    for place in places!{
                        let marker = self.placeMarker(latitude: place.latitude!, longitude: place.longitude!, image: place.marker(searchPlace: params["type"] as! String))
                        marker.map = self.googleMapView
                    }
                }
                
                if !(nextPageToken?.isEmpty)!{
                    var nextParam: [String: Any] = ["pagetoken": nextPageToken!]
                    nextParam["key"] = ConfigurationManager.googleServicesAPIKey()
                    self.fetchPlaces(params: nextParam)
                }
            }
        }
    }

    func placeMarker(latitude: Double, longitude:Double, image: String) -> GMSMarker{
        let startPosition = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let startMArker = RouteMarker(position: startPosition)
        startMArker.icon = UIImage(named: image)
        return startMArker
    }

    //MARK: IBAction Methods
    @IBAction func wishlistButtonTapped(sender : UIButton){
        self.addRouteToMyWishList()
    }
    
    @IBAction func shareButtonTapped(sender : UIButton){
        self.route?.share()
    }
    
}
