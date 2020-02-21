//
//  GroupDetailsViewController+TableView.swift
//  Tripp
//
//  Created by Bharat Lal on 02/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import UIKit

extension GroupDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if group.status == MemberStatus.accepted.rawValue {
            return feeds.count
        } else if group.status == MemberStatus.invited.rawValue {
            return 1
        }
        return 0
    }
    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            loadMore()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if group.status == MemberStatus.invited.rawValue {
            return adminCellAt(indexPath)
        }
        return feedCellAt(indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if group.status != MemberStatus.invited.rawValue, AppUser.currentUser().subscription() != .subscribed {
            let feed = self.feeds[indexPath.row]
            if feed.userId != AppUser.sharedInstance?.userId {
                self.presentSubscriptionController()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if group.status == MemberStatus.invited.rawValue {
            return 60
        }
        return 121
    }
    // MARK: - private
    private func adminCellAt(_ indexPath: IndexPath) -> GroupMemberTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupMemberTableViewCell.identifier, for: indexPath) as! GroupMemberTableViewCell
        cell.emailLabel.text = group.admin?.fullName
        if let url = group.admin?.profileImage, url.isEmpty == false{
            cell.avtar.imageFromS3(url, handler: { (image) in
                cell.avtar.image = image
            })
        }
        let separator = UIView()
        //separator.backgroundColor = UIColor.separatorColor() //xr
        separator.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 1, width: cell.contentView.frame.size.width, height: 1)
        cell.contentView.addSubview(separator)
        return cell
    }
    private func feedCellAt(_ indexPath: IndexPath) -> GroupFeedTableViewCell {
        let feed = self.feeds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupFeedTableViewCell.identifier, for: indexPath) as! GroupFeedTableViewCell
        cell.shareButton.addTarget(self, action: #selector(GroupDetailsViewController.shareTapped(_:)), for: .touchUpInside)
        cell.detailsButton.addTarget(self, action: #selector(GroupDetailsViewController.detailsTapped(_:)), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(GroupDetailsViewController.toggleLike(_:)), for: .touchUpInside)
        cell.detailsButton.tag = indexPath.row
        cell.shareButton.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        cell.fillWithFeed(feed)
        
        if let url = feed.trip?.imageURL, url.isEmpty == false{
            cell.imageIcon.imageFromS3(url, handler: { [weak self] image in
                if let currentCell = self?.tableView.cellForRow(at: indexPath) as? GroupFeedTableViewCell{
                    currentCell.imageIcon.image = image
                }
            })
        }
        
        if AppUser.currentUser().subscription() != .subscribed {
            cell.blurView.isHidden = AppUser.sharedInstance?.userId == feed.userId
        } else {
            cell.blurView.isHidden = true
        }
        
        return cell
    }
    private func shareFeedAt(_ index: Int) {
        let route = feeds[index].trip
        route?.share()
    }
    private func shareTripWithGroup(_ index: Int) {
        if let route = feeds[index].trip{
            pushToShareTrip(route.tripId, originGroup: group)
        }
    }
    
    // MARK: - Cell button events
    @objc func shareTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to share:", preferredStyle: .actionSheet)
         
        let otherGoupAction = UIAlertAction(title: "In other group", style: .default, handler: { [weak self] (action) -> Void in
            
            self?.shareTripWithGroup(sender.tag)
        })
        let socialMediaAction = UIAlertAction(title: "On social media", style: .default, handler: { [weak self] (action) -> Void in
            self?.shareFeedAt(sender.tag)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(otherGoupAction)
        alertController.addAction(socialMediaAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @objc func toggleLike(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isUserInteractionEnabled = false
        let feed = feeds[sender.tag]
        let likeCount = (feed.isLiked == 1) ? feed.totalLikeCount - 1 : feed.totalLikeCount + 1
        
        sender.setTitle("\(likeCount)", for: .normal)
        sender.setTitle("\(likeCount)", for: .selected)
        feed.toggleLike { (message, error) in
            sender.isUserInteractionEnabled = true
            if error != nil {
                sender.isSelected = !sender.isSelected
                sender.setTitle("\(feed.totalLikeCount)", for: .normal)
                sender.setTitle("\(feed.totalLikeCount)", for: .selected)
            }
        }
    }
    
    @objc func detailsTapped(_ sender: UIButton) {
        guard let route = feeds[sender.tag].trip else {
            return
        }
        if route.tripMode == TripMode.Live.rawValue{
            presentLiveTripView(route: route)
        }else{
            self.pushTripDetails(withRoute: route, fromGroup: true)
        }
    }
    func presentLiveTripView(route: Route){
        
        guard let _ = route.polylineString else {
            fetchPlyline(route)
            return
        }
        self.presentLiveTripController(route, fromGroups: true)
    }
    private func fetchPlyline(_ route: Route) {
        guard let fileName = route.fileUrl else {
            return
        }
        AppLoader.showLoader()
        AWSImageManager.sharedManger.downloadFileFromS3(fileName) { [weak self] (status, fileUrl) in
            AppLoader.hideLoader()
            if let url = fileUrl {
                do{
                    let routePathString = try String(contentsOf: url)
                    route.polylineString = routePathString as NSString
                    self?.presentLiveTripController(route, fromGroups: true)
                }
                catch{
                    // Do nothing
                    DLog(message: "google rrrr exce" as AnyObject)
                }
            }
        }
    }
}
