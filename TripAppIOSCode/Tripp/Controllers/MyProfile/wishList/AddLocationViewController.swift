//
//  AddLocationViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 15/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMaps

protocol AddLocationDelegate {
    func locationAdded()
}

class AddLocationViewController: UIViewController {
    
    //MARK: IBOutlet/ variables
    let topBar = AddTripTopBar.initializeBar()
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var savePointButton: RoundedButton! 
    @IBOutlet weak var messageLabel: CharacterSpaceLabel!
    
    lazy var searchViewController: SearchViewController = {
        // Instantiate View Controller
        var viewController = homeStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.sarchViewController.rawValue) as! SearchViewController
        
        return viewController
    }()
    var isDragignMarker = false
    var selectedLocation: Wayponit?
    var delegate: AddLocationDelegate?
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.mapView.addMapTypeToggleButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: IBActions
    @IBAction func locationTapped(_ sender: Any) {
        showCurrentLocationOnMap()
    }
    @IBAction func savePointTapped(_ sender: RoundedButton) {
        if self.topBar.tripNameTextField.isEmpty(){
            AppToast.showErrorMessage(message: addLocationNameMessage)
        }
        else if let location = selectedLocation{
            AppLoader.showLoader()
            let name = self.topBar.tripNameTextField.text == nil ? "" : self.topBar.tripNameTextField.text!
             let date = self.topBar.tripDateTextField.text == nil ? "" : self.topBar.tripDateTextField.text!
            APIDataSource.addLocationToWistList(service: .addLocationWish(latitude: location.latitude, longitude: location.longitude, address: location.address, name: name, date: date), handler: { (message, error) in
                AppLoader.hideLoader()
                if let _ = message{
                    AppToast.showSuccessMessage(message: message!)
                    self.popViewController()
                    if let _ = self.delegate{
                        self.delegate!.locationAdded()
                    }
                }else{
                    AppToast.showErrorMessage(message: error!)
                }
            })
        }
    }
    //MARK: Private / Helper
    private func setupView(){
        self.view.addSubview(self.topBar)
        self.mapView.delegate = self
        self.setupTopBar()
        self.savePointButton.isHidden = true
        showCurrentLocationOnMap()
        addShadowAndCornerRadius()
        self.bringSearchView()
    }
    private func setupTopBar(){
        topBar.searchField.delegate = self
        topBar.searchField.addTarget(self, action: #selector(AddLocationViewController.textFieldDidChange(_:)), for: .editingChanged)
        topBar.closeButton.addTarget(self, action: #selector(AddLocationViewController.closeButtonTapped(_:)), for: .touchUpInside)
        self.topBar.fillTripDetails(name: "", date: "", tripType: .None)
        self.topBar.tripNameTextField.isHidden = false
         self.topBar.tripNameTextField.text = ""
        self.topBar.tripDateTextField.isHidden = true
        self.topBar.nameLabel.isHidden = true
        self.topBar.dateLabel.isHidden = true
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
    private func addShadowAndCornerRadius(){
        footerView.roundCorner([.topLeft, .topRight], radius: 12)
        footerView.layer.masksToBounds = false
        footerView.layer.shadowOffset = CGSize(width: 2, height: -6)
        footerView.layer.shadowRadius = 11
        footerView.layer.shadowOpacity = 11
        footerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.21).cgColor
    }
    @objc func closeButtonTapped(_ sender: Any?){
        if self.topBar.isExpand{
            topBar.searchField.text = ""
            topBar.searchButtonTapped(sender)
        }else{
            self.popViewController()
        }
    }
   
}

