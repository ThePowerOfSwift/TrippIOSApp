//
//  RoutList+TableView.swift
//  Tripp
//
//  Created by Bharat Lal on 11/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension RouteListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let route = self.routesList[indexPath.row]
        if route.role == UserRole.AdMob.rawValue{
            let cell = tableView.dequeueReusableCell(withIdentifier: AdMobBannerCell.cellIdentifier, for: indexPath) as! AdMobBannerCell
            cell.loadBanner()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: RouteTableViewCell.identifier, for: indexPath) as! RouteTableViewCell
            cell.shareButton.addTarget(self, action: #selector(RouteListViewController.shareTapped(_:)), for: .touchUpInside)
            cell.detailsButton.addTarget(self, action: #selector(RouteListViewController.detailsTapped(_:)), for: .touchUpInside)
            cell.detailsButton.tag = indexPath.row
            cell.shareButton.tag = indexPath.row
            cell.fillWithRoute(route)
            
            if !route.imageURL.isEmpty{
                cell.imageIcon.imageFromS3(route.imageURL, handler: { (image) in
                    if let currentCell = tableView.cellForRow(at: indexPath) as? RouteTableViewCell{
                        currentCell.imageIcon.image = image
                    }
                })
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentPage*perPageItmes == (indexPath.item + 1) {
            currentPage += 1
            if (self.parent as! RoutesBaseViewController).topView?.selectedTab == .Routes{
                self.fetchRoutes(nearBy: userLocation!)
            }
        }
    }
    
    //Cell button events
    @objc func shareTapped(_ sender: UIButton) {
        let route = self.routesList[sender.tag]
        route.share()
    }
    
    @objc func detailsTapped(_ sender: UIButton) {
        if let parentVC = self.parent as? RoutesBaseViewController, let topView = parentVC.topView{
            let route = self.routesList[sender.tag]
            if topView.selectedTab == .Routes{
                self.pushRouteDetails(route: route)
            }else {
                if (self.parent as? MyTripsViewController)?.groupMember == nil {
                    if route.tripMode == TripMode.Live.rawValue{
                        self.presentLiveTripController(route)
                    }else {
                        self.pushTripDetails(withRoute: route)
                    }
                } else {
                    if route.tripMode == TripMode.Live.rawValue{
                        //self.presentLiveTripController(route)
                        self.presentLiveTripController(route, fromGroups: true)
                    } else {
                        self.pushTripDetails(withRoute: route, groupMemberId: (self.parent as? MyTripsViewController)?.groupMember?.groupUserId.value, fromGroup: false)
                    }
                    
                }
            }
            
//            if route.tripMode == TripMode.Live.rawValue{
//                self.presentLiveTripController(route)
//            }else{
//                if  (self.parent as? MyTripsViewController)?.groupMember == nil {
//                    self.pushTripDetails(withRoute: route)
//                } else {
//                    self.pushTripDetails(withRoute: route, groupMemberId: (self.parent as? MyTripsViewController)?.groupMember?.groupUserId.value, fromGroup: true)
//                }
//                
//            }
        }
        
    }
}
