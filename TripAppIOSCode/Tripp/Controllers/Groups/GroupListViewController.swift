//
//  GroupListViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 12/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController {
    // MARK: - IBOutlates / variables
    @IBOutlet weak var tableView: UITableView!
    
    var groups = [Group]()
    var paging: Paging!
    var loading: Bool = false
    var fromNotification: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let tabbarVC = self.tabBarController as? AppTabBarController, let groupId = tabbarVC.groupID, fromNotification == true {
            fromNotification = false
            //pushGroupDetails(group)
            AppLoader.showLoader()
            APIDataSource.groupInfo(service: .groupInfo(groupId: groupId), handler: { [weak self] (group, error) in
                AppLoader.hideLoader()
                if let grp = group {
                    self?.pushGroupDetails(grp)

                } else {
                    AppToast.showErrorMessage(message: error ?? someErrorMessage)
                    self?.groups.removeAll()
                    self?.loadData()
                }
            })
        } else {
            groups.removeAll()
            loadData()
        }
        
    }
    //MARK: - IBActions
    @IBAction func createGroupAction(_ sender: UIButton) {
        if AppUser.currentUser().subscription() == .subscribed {
            presentCreateGroupController()
        } else {
            presentSubscriptionController()
        }
    }
    //MARK: - Helper
    func loadMoreData() {
        if !loading && paging != nil  && paging.currentPage < paging.lastPage {
            loading = true
            loadData(false, pageNumber: paging.currentPage + 1)
        }
    }
    func dataLoaded(_ data: [Group]) {
        groups.append(contentsOf: data)
        tableView.reloadData()
    }
    //MARK: - Private/helper
    private func loadData(_ showLoader: Bool = true, pageNumber page: Int = 0) {
        if showLoader == true { AppLoader.showLoader() }
        APIDataSource.groupListing(service: .groupList(page: page)) { [weak self] (groups, page, error) in
            if showLoader == true { AppLoader.hideLoader() }
            if let allGroups = groups, allGroups.count > 0 {
                self?.paging = page
                self?.dataLoaded(allGroups)
            }
            self?.loading = false
        }

    }

}
