//
//  GroupListViewController+TableView.swift
//  Tripp
//
//  Created by Bharat Lal on 13/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

extension GroupListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupMainTableViewCell.identifier, for: indexPath) as! GroupMainTableViewCell
        let group = groups[indexPath.row]
        cell.groupName.text = group.name
        cell.groupDetail.text = group.totalMembers.description + " Members | " + group.totalTrips.description + " Trips"
        if let url = group.image, url.isEmpty == false{
            cell.groupImageView.imageFromS3(url, handler: { (image) in
                if let currentCell = tableView.cellForRow(at: indexPath) as? GroupMainTableViewCell{
                    currentCell.groupImageView.image = image
                }
            })
        } else {
            cell.groupImageView.image = #imageLiteral(resourceName: "IcGroupPlaceholder")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        pushGroupDetails(group)
    }
    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            loadMoreData()
        }
    }
}
