//
//  SearchViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 21/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GooglePlaces

typealias PlaceSelectedCallback = (_ place: GMSPlace) -> ()
typealias StateSelectedCallback = (_ state: State) -> ()

enum SearchMode {
    case GooglePlaces
    case States
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var callback: PlaceSelectedCallback?
    var stateCallBack: StateSelectedCallback?
    var places = [NearByPlace]()
    var states = State.statesArray()
    var filteredStates = [State]()
    var searchMode = SearchMode.GooglePlaces
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    // search with google place API
    func searchForPlace(_ text: String, callback: @escaping PlaceSelectedCallback){
        if text.characters.count >= 3{
            searchWithText(text: text)
            self.callback = callback
        }
    }
    fileprivate func searchWithText(text: String){
        var params: [String: Any] = [:]
        params["key"] = ConfigurationManager.googleServicesAPIKey()
        params["language"] = "en"
        params["input"] = text
        
        APIDataSource.searchPlaces(params: params) { (places, error) in
            if places != nil{
                self.places = places!
                self.tableView.reloadData()
            }
        }
    }
    //Search for states
    func searchForState(_ text: String, callback: @escaping StateSelectedCallback){
        if self.states != nil && self.states?.count != 0{
             self.stateCallBack = callback
            self.searchForStateWithText(text: text)
        }else{
            if text.characters.count >= 3{
                
                AppLoader.showLoader()
                APIDataSource.fetchStates(handler: { (states, error) in
                    AppLoader.hideLoader()
                    if let _ = states{
                        self.states = State.statesArray()
                        self.searchForStateWithText(text: text)
                    }
                })
            }
        }
        
    }
    fileprivate func searchForStateWithText(text: String){
        
        if let states = State.searchWithText(text: text){
            self.filteredStates = states
        }
        self.tableView.reloadData()
    }
    fileprivate func placeTapped(_ selectedPlace: NearByPlace){
        GMSPlacesClient.shared().lookUpPlaceID(selectedPlace.placeId!, callback: { (place, error) -> Void in
            if let error = error {
                DLog(message: "lookup place id query error: \(error.localizedDescription)" as AnyObject)
                return
            }
            guard let place = place else{
                 DLog(message: "no details found" as AnyObject)
                return
            }
            
            if let handler = self.callback{
                handler(place)
            }
        })
    }
    fileprivate func stateTapped(_ state: State){
        if let handler = self.stateCallBack{
            handler(state)
        }
    }
    //MARK: table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchMode == .GooglePlaces{
            return places.count
        }
        return self.filteredStates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if searchMode == .GooglePlaces{
            let place = places[indexPath.row]
            cell.textLabel?.text = place.placeDescription
            cell.textLabel?.addCharactersSpacing(spacing: -0.6, text: place.placeDescription!)
        }else{
            let state = self.filteredStates[indexPath.row]
            cell.textLabel?.text = state.name
            cell.textLabel?.addCharactersSpacing(spacing: -0.6, text: (state.name)!)
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.openSensRegular(size: 16)
        cell.textLabel?.textColor = UIColor.searchTableRowTextColor()
       
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchMode == .GooglePlaces{
            placeTapped(places[indexPath.row])
        }else{
            stateTapped(filteredStates[indexPath.row])
        }
    }

}
