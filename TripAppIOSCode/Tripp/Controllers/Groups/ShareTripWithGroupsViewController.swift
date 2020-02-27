//
//  ShareTripWithGroupsViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 06/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class ShareTripWithGroupsViewController: GroupListViewController {
    
    @IBOutlet weak var shareButton: RoundedBorderButton!
    var tripId: Int!
    var selectedIndex: IndexPath?
    var originGroup: Group!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        shareButton.addCharacterSpace(space: -0.3)
        shareButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func dataLoaded(_ data: [Group]) {
         let filteredGroups = data.filter( { $0.groupId != originGroup.groupId } )
        groups.append(contentsOf: filteredGroups)
        tableView.reloadData()
    }
    // MARK: IBActions
    @IBAction func backActions(_ sender: Any) {
        popViewController()
    }
    @IBAction func shareActions(_ sender: Any) {
        if let index = selectedIndex?.row {
            let group = groups[index]
            AppLoader.showLoader()
            group.shareTripWithGroup(tripId, { (message, error) in
                AppLoader.hideLoader()
                if let err = error {
                    AppToast.showErrorMessage(message: err)
                } else if let msg = message {
                    AppToast.showSuccessMessage(message: msg)
                }
            })
        }
    }
}

extension ShareTripWithGroupsViewController {

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ShareTripInGroupTableViewCell.identifier, for: indexPath) as! ShareTripInGroupTableViewCell
        let group = groups[indexPath.row]
        cell.configureCellWith(group)
        if let url = group.image, url.isEmpty == false{
            cell.groupImageView.imageFromS3(url, handler: { (image) in
                if let currentCell = tableView.cellForRow(at: indexPath) as? ShareTripInGroupTableViewCell{
                    currentCell.groupImageView.image = image
                }
            })
        } else {
            cell.groupImageView.image = #imageLiteral(resourceName: "IcGroupPlaceholder")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        group.isSelected = !group.isSelected
        if let previousIndex = selectedIndex {
            let pgroup = groups[previousIndex.row]
            pgroup.isSelected = !pgroup.isSelected
            tableView.reloadRows(at: [indexPath, previousIndex], with: .fade)
        }else {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        selectedIndex = indexPath
        shareButton.isEnabled = true
    }
}
