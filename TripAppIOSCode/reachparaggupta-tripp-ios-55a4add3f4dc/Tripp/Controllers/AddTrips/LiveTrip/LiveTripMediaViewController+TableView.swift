//
//  LiveTripMediaViewController+TableView.swift
//  Tripp
//
//  Created by Bharat Lal on 21/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension LiveTripMediaViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if parentController.fromGroups == true {
            if let mediaCount = self.waypoints.first?.waypointMedia.count, mediaCount > 0 {
                return 2
            }
            return 1
        }
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 150
        }
        if isExpandMedia {
            return self.heightOfCollectionView() + 93
        }else{
            let cellHeight = (Global.screenRect.size.width - 69) / 5
            return cellHeight + 93
        }
    }
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        guard let mediaCell = cell as? LiveTripMediaTableViewCell else { return }
        
        mediaCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            return configureLocationInfoCellAtIndexPath(indexPath)
        }else{
            
            return configureMediaCellAtIndexPath(indexPath)
        }
    }
    
    
    //MARK: Helper
    private func configureLocationInfoCellAtIndexPath(_ indexPath: IndexPath) -> LiveTripLocationInfoTableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveTripLocationInfoTableViewCell.identifier, for: indexPath) as! LiveTripLocationInfoTableViewCell
        cell.startAddressLabel.text = startAddress
        cell.currentAddressLabel.text = currentAddress
        cell.currentLabel.text = isEditMode ? "End location" : "Current location"
        return cell
        
    }
    private func configureMediaCellAtIndexPath(_ indexPath: IndexPath) -> LiveTripMediaTableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: LiveTripMediaTableViewCell.identifier, for: indexPath) as! LiveTripMediaTableViewCell
        if let waypoint = self.waypoints.first {
            cell.photoCountLabel.text = "\(waypoint.imagesCount) Photos"
            cell.videoCountLabel.text = "\(waypoint.videoCount) Videos"
            cell.expandCollapseButton.tag = indexPath.row
            cell.expandCollapseButton.addTarget(self, action: #selector(LiveTripMediaViewController.expandOrCollapseCell(_:)), for: .touchUpInside)
            cell.expandCollapseButton.isHidden = waypoint.waypointMedia.count <= 4 ? true : false
            cell.expandCollapseButton.setTitle((isExpandMedia ? "Close" : "Expand view"), for: .normal)
        }
        return cell
    }
    private func heightOfCollectionView() -> CGFloat{
        let totalRows = ceil((Double((self.waypoints.first?.waypointMedia.count)!) + 1.0) / 5.0)
        let totalSpace = (totalRows - 1) * 5
        let cellHeight = (Global.screenRect.size.width - 69) / 5
        return (CGFloat(totalRows) * cellHeight) + CGFloat(totalSpace)
    }
    //MARK: Target
    @objc func expandOrCollapseCell(_ sender: UIButton){
        self.isExpandMedia = !self.isExpandMedia
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
