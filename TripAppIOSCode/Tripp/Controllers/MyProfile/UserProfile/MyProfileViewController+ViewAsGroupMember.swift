//
//  MyProfileViewController+ViewAsGroupMember.swift
//  Tripp
//
//  Created by Bharat Lal on 04/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import UIKit

extension MyProfileViewController {
    func setupviewAsGroupMember(_ member: GroupMember) {
        updateViews(member)
        if let memberId = member.groupUserId.value {
            fetchProfile(memberId)
        } else {
            AppToast.showErrorMessage(message: "This user haven't joined Tripp yet.")
        }
        
    }
    private func updateViews(_ member: GroupMember) {
        editNameButton.isHidden = true
        editVehicleButton.isHidden = true
        topRightButton.setImage(#imageLiteral(resourceName: "tab_routes_selected"), for: .normal)
        wishListIconView.isHidden = true
        titleLabel.text = member.fullName ?? member.email
        vehicleInfoLabel.text = (member.fullName ?? "User") + " VEHICLE DETAILS"
    }
    private func fetchProfile(_ userId: Int) {
        AppLoader.showLoader()
        APIDataSource.userStatistic(service: .userProfile(userId: userId)) { [weak self] (user, error) in
            AppLoader.hideLoader()
            if let anUser = user{
                self?.fillProfileInfo(anUser)
                self?.populateInfo(anUser)
            }
        }
    }
}
