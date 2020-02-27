//
//  GroupMembersViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 13/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class GroupMembersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMoreButton: RoundedBorderButton!
    @IBOutlet weak var tableViewBottomConstarint: NSLayoutConstraint!
    
    var groupMembers = [GroupMember]()
    var group: Group!
    var paging: Paging!
    var loading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupMembers.removeAll()
         loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - IBActions
    @IBAction func backAction(_ sender: Any) {
        popViewController()
    }
    @IBAction func addMoreAction(_ sender: Any) {
        if AppUser.currentUser().subscription() != .subscribed {
            self.presentSubscriptionController()
        } else {
            presentAddMorePeople(group)
        }
    }
    //MARK: - Private/helper
    private func setupUI() {
        tableView.tableFooterView = UIView()
        if group.role == GroupRole.member.rawValue {
            addMoreButton.isHidden = true
            tableViewBottomConstarint.constant = 0
        }
        addMoreButton.addCharacterSpace(space: -0.5)
        addMoreButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22)
    }
    private func loadData(_ showLoader: Bool = true, pageNumber page: Int = 0) {
        if showLoader == true { AppLoader.showLoader() }
        APIDataSource.groupMemberListing(service: .groupMemberList(groupId: group.groupId, page: page)) { [weak self] (members, page, error) in
            if showLoader == true { AppLoader.hideLoader() }
            if let allMembers = members, allMembers.count > 0 {
                self?.groupMembers.append(contentsOf: allMembers)
                self?.tableView.reloadData()
                self?.paging = page
            }
            self?.loading = false
        }
        
    }
    // MARK: - Helper
    func loadMore() {
        if !loading && paging != nil  && paging.currentPage < paging.lastPage {
            loading = true
            loadData(false, pageNumber: paging.currentPage + 1)
        }
    }
}
