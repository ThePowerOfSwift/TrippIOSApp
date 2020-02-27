//
//  WishList+TableView.swift
//  Tripp
//
//  Created by Bharat Lal on 28/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension WishListViewController: UITableViewDelegate, UITableViewDataSource, CategoryPickerDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.listType == .Location{
            return locationListArray.count
        }
        if listType == .Places {
            return wishPlaces.count
        }
        return wishListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishlistTableViewCell.identifier, for: indexPath) as! WishlistTableViewCell
        if self.listType == .Location{
            let wish = self.locationListArray[indexPath.row]
            cell.populateWithLocation(wish)
        }else if listType == .Route{
            let wish = self.wishListArray[indexPath.row]
            cell.populateWith(wish)
        } else {
            let wish = wishPlaces[indexPath.row]
            cell.populateWithPlace(wish)
        }
        self.addTargetForButtonsOn(cell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    //MARK: Helper
    func addTargetForButtonsOn(cell: WishlistTableViewCell, atIndexPath indexPath: IndexPath){
        cell.viewButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.plusButton.tag = indexPath.row
        cell.viewButton.addTarget(self, action: #selector(WishListViewController.viewDetailsTapped(sender:)), for: .touchUpInside)
        cell.shareButton.addTarget(self, action: #selector(WishListViewController.shareTapped(sender:)), for: .touchUpInside)
        cell.plusButton.addTarget(self, action: #selector(WishListViewController.plusTapped(sender:)), for: .touchUpInside)
    }
    @objc func viewDetailsTapped(sender: UIButton){
         if self.listType == .Location{
            let wish = self.locationListArray[sender.tag]
            pushToLocationdetails(wish)
         }else if listType == .Route {
            loadRouteWishDetailsAtIndex(sender.tag)
         } else {
            let wish = wishPlaces[sender.tag]
            wish.isAddedToWishlist = 1
            pushPlacesDetails(wish)
        }
        
    }
    private func loadRouteWishDetailsAtIndex(_ index: Int){
        let wish = self.wishListArray[index]
        AppLoader.showLoader()
        APIDataSource.tripDetails(service: .fetchTripDetail(tripId: wish.tripId)) { (route, error) in
            AppLoader.hideLoader()
            if let trip = route{
                self.pushRouteDetails(route: trip, isUserWish: true)
            }else{
                AppToast.showErrorMessage(message: error!)
            }
        }
    }
    @objc func shareTapped(sender: UIButton){
        if self.listType == .Location{
            let wish = self.locationListArray[sender.tag]
            wish.share()
        }else if listType == .Route {
            let wish = self.wishListArray[sender.tag]
            wish.share()
        } else {
            let wish = wishPlaces[sender.tag]
            wish.share()
        }
    }
    @objc func plusTapped(sender: UIButton){
        fetchCategories()
        selectedWish = self.wishListArray[sender.tag]
    }
    
    //MARK: - CategoryPickerDelegate
    func skip()  {
        self.categoryId = ""
        addToMyTrip()
    }
    func addToMyTrip() {
        pickerView?.isHidden = true
        guard let wish = selectedWish else {
            return
        }
        AppLoader.showLoader()
        
        APIDataSource.addRouteToWishList(service: .addToMyTrip(tripId: wish.tripId, categoryId: self.categoryId)) { (message, error) in
            AppLoader.hideLoader()
            if error == nil{
                wish.trip?.isMyTrip = true
                self.wishListTableView.reloadData()
                AppToast.showSuccessMessage(message: message!)
            }else{
                AppToast.showErrorMessage(message: error!)
            }
            
        }
        
    }
    
}
