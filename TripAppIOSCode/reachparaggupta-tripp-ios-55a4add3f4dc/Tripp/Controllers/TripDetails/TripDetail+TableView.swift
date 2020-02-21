//
//  TripDetail+TableView.swift
//  Tripp
//
//  Created by Monu on 09/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

enum MediaCellExpand: CGFloat {
    case small = 133.0
    case large = 365.0
}

extension TripDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.route?.waypoints.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return (self.expandedIndexPath?.item == indexPath.item) ? MediaCellExpand.large.rawValue : MediaCellExpand.small.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RouteWaypointCell.cellIdentifier, for: indexPath) as! RouteWaypointCell
        self.showPointName(atIndex: indexPath, cell: cell)
        cell.populateCell(waypoint: (self.route?.waypoints[indexPath.item])!, indexPath: indexPath, isShowMedia: (self.expandedIndexPath?.item == indexPath.item) ? true : false)
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
    
    //MARK: IBAction Methods
    @IBAction func closeExpandButtonTapped(_ sender: UIButton) {
        if let indexPath = self.expandedIndexPath {
            if indexPath.item != sender.tag{
                self.expandedIndexPath = nil
                self.detailsTableView.reloadRows(at: [indexPath], with: .fade)
                self.expandedIndexPath = IndexPath(item: sender.tag, section: 0)
                self.detailsTableView.reloadRows(at: [self.expandedIndexPath!], with: .fade)
            }
            else{
                self.expandedIndexPath = nil
                self.detailsTableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        else{
            self.expandedIndexPath = IndexPath(item: sender.tag, section: 0)
            self.detailsTableView.reloadRows(at: [self.expandedIndexPath!], with: .fade)
        }
    }
    
}
