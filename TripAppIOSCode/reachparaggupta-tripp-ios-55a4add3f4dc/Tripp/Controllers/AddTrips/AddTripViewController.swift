//
//  AddTripViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 19/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps

class AddTripViewController: UIViewController {

    //MARK: Variables/IBOutlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    var createTripWasTapped = false
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isLiveTrcking = AppUserDefaults.value(for: .livetrackingOn) as? Bool, isLiveTrcking == true {
            presentLiveTripController()
        }else{
            self.setupUI()
        }
        self.addObserver()
        self.mapView.addMapTypeToggleButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if createTripWasTapped == true {
            self.dismiss(animated: true, completion: nil)
        }
        createTripWasTapped = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: ------ Private
    private func setupUI(){
        self.mapView.isMyLocationEnabled = true
        self.showCurrentLocationOnMap()
        self.setupHeaderCornerRounded()
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(AddTripViewController.openMyTripTab(notification:)), name: AppNotification.gotoMyTrip, object: nil)
    }
    
    /**
     * @method showCurrentLocationOnMapAndFtechRoutes
     * @discussion show current location on the Map and start Fteching Routes.
     */
    private func showCurrentLocationOnMap(){
        LocationManager.sharedManager.currentLocation(complitionHandler: {(location, error) in
            guard let _ = error else {
                self.mapView.moveMapToUserlocation(location!)
                return
            }
        })
    }
    private func setupHeaderCornerRounded() {
        self.headerView.roundCorner([.bottomLeft, .bottomRight], radius: 12)
    }
    
    @objc func openMyTripTab(notification: Notification){
        self.tabBarController?.selectedIndex = 1
    }
    
    //MARK: IBActions
    @IBAction func locationTapped(_ sender: Any) {
        showCurrentLocationOnMap()
        
    }
    @IBAction func addTripTapped(_ sender: Any) {
        createTripWasTapped = true
        presentAddTripController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
