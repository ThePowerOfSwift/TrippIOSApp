//
//  RouteDetails+TableView.swift
//  Tripp
//
//  Created by Monu on 17/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension RouteDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.route?.waypoints.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return (self.expandedIndexPath?.item == indexPath.item) ? MediaCellExpand.large.rawValue : MediaCellExpand.small.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RouteWaypointCell.cellIdentifier, for: indexPath) as! RouteWaypointCell
        cell.populateCell(waypoint: (self.route?.waypoints[indexPath.item])!, indexPath: indexPath, isShowMedia: (self.expandedIndexPath?.item == indexPath.item) ? true : false)
        self.showPointName(atIndex: indexPath, cell: cell)
        return cell
    }
    
    private func showPointName(atIndex: IndexPath, cell: RouteWaypointCell){
        if atIndex.item == 0 {
            cell.pointNameLabel.text = startingPointMessage
            cell.pointLogo.image = UIImage(named: icStartPoint)
        }
        else if atIndex.item == (self.route?.waypoints.count)!-1{
            cell.pointNameLabel.text = finalPointMessage
            cell.pointLogo.image = UIImage(named: icFinalPoint)
        }
        else{
            cell.pointNameLabel.text = waypointMessage
            cell.pointLogo.image = UIImage(named: icWayPoint)
        }
    }
}
