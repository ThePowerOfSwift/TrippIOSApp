//
//  GroupMembersViewController+TableView.swift
//  Tripp
//
//  Created by Bharat Lal on 13/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

extension GroupMembersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupMemberTableViewCell.identifier, for: indexPath) as! GroupMemberTableViewCell
        let user = groupMembers[indexPath.row]
        cell.fillDataFor(user)
        if let url = user.profileImage, url.isEmpty == false{
            cell.avtar.imageFromS3(url, handler: { (image) in
                if let currentCell = tableView.cellForRow(at: indexPath) as? GroupMemberTableViewCell{
                    currentCell.avtar.image = image
                }
            })
        }
        return cell
    }
    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            loadMore()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = groupMembers[indexPath.row]
        if AppUser.currentUser().subscription() != .subscribed && AppUser.currentUser().userId != user.groupUserId.value {
            self.presentSubscriptionController()
            return
        }
        
        guard let _ = user.groupUserId.value else{
            AppToast.showErrorMessage(message: "This user haven't joined Tripp yet.")
            return
        }
        pushToProfile(user)
    }
    //-- Delete Row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let user = groupMembers[indexPath.row]
        if user.email == AppUser.currentUser().email {
            return false
        }
        return group.role == GroupRole.admin.rawValue ? true : false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Utils.openAlertViewFromViewController(self, title: "Remove Member", message: "Are you sure you want to remove this member from the group", buttonsTitlesAndTypesArray: [(name: "Cancel", type: .cancel), (name: "Remove", type: .destructive)], completionHandler: { [weak self] (alert, index) in
                if index == 1 {
                    self?.removeMemberAt(indexPath)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
}
extension GroupMembersViewController {
    fileprivate func removeMemberAt(_ indexPath: IndexPath) {
        let member = groupMembers[indexPath.row]
        AppLoader.showLoader()
        group.removeMember(member.email) {[weak self] (message, error) in
            AppLoader.hideLoader()
            guard let err = error else {
                self?.groupMembers.remove(at: indexPath.row)
                self?.tableView.beginUpdates()
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
                self?.tableView.endUpdates()
                return
            }
            AppToast.showErrorMessage(message: err)
        }
    }
}
