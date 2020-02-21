//
//  GroupDetailsViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 02/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController {
    
    // MARK: - IBOutlates / variables
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupName: CharacterSpaceLabel!
    @IBOutlet weak var groupDetail: CharacterSpaceLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMemberButton: RoundedBorderButton!
    @IBOutlet weak var fotterView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var acceptButton: RoundedBorderButton!
    @IBOutlet weak var rejectButton: RoundedBorderButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var feeds = [FeedData]()
    var group: Group!
    var paging: Paging!
    var loading: Bool = false
    var viewMemberView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewMemberView = headerView
        setup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        updateGroupInfo()
        tableView.reloadData()
    }
    // MARK: - IBAction
    @IBAction func backAction(_ sender: UIButton) {
        self.popViewController()
    }
    @IBAction func viewMembers(_ sender: UIButton) {
        pushToGroupMembers(group)
    }
    @IBAction func acceptInvitation(_ sender: UIButton) {
        AppLoader.showLoader()
        group.updateMembership(.accepted) { [weak self] (message, error) in
            AppLoader.hideLoader()
            if error == nil {
                self?.setupView()
            } else {
                AppToast.showErrorMessage(message: error ?? someErrorMessage)
            }
        }
    }
    @IBAction func rejectInvitation(_ sender: UIButton) {
         AppLoader.showLoader()
        group.updateMembership(.rejected) { [weak self] (message, error) in
            AppLoader.hideLoader()
            if error == nil {
                self?.popViewController()
            } else {
                AppToast.showErrorMessage(message: error ?? someErrorMessage)
            }
        }
    }
    @IBAction func menuAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "Choose Action:", preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "Edit Group", style: .default, handler: { [weak self] (action) -> Void in
            self?.presentCreateGroupController(self?.group)
            
            
        })
        let addMembers = UIAlertAction(title: "Add Members", style: .default, handler: { [weak self] (action) -> Void in
            if let weakSelf = self{
            weakSelf.presentAddMorePeople(weakSelf.group)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(edit)
        alertController.addAction(addMembers)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    // MARK: - Private
    private func  setup() {
        tableView.register(GroupFeedTableViewCell.nib, forCellReuseIdentifier: GroupFeedTableViewCell.identifier)
        updateGroupInfo()
        setupView()
        setupButtons()
    }
    private func updateGroupInfo() {
        groupDetail.text = group.totalMembers.description + " Members | " + group.totalTrips.description + " Trips"
         groupName.text = group.name
        setupImageView()
    }
    private func setupView() {
        if group.status == MemberStatus.accepted.rawValue {
            tableView.tableFooterView = nil
            tableView.tableHeaderView = self.viewMemberView
            tableView.reloadData()
            fetchFeeds()
        } else if group.status == MemberStatus.invited.rawValue {
            tableView.tableFooterView = fotterView
            tableView.tableHeaderView = nil
        }
        if group.role == GroupRole.member.rawValue {
            menuButton.isHidden = true
        }
    }
    private func setupButtons() {
        viewMemberButton.addCharacterSpace(space: -0.5)
        viewMemberButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22.0)
        acceptButton.addCharacterSpace(space: -0.3)
        acceptButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22.0)
        rejectButton.addCharacterSpace(space: -0.3)
        rejectButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22.0)
    }
    private func setupImageView() {
        
        if let url = group.image, url.isEmpty == false{
            groupImageView.imageFromS3(url, handler: { [weak self] (image) in
                self?.groupImageView.image = image
            })
        } else {
            groupImageView.image = #imageLiteral(resourceName: "IcGroupPlaceholder")
        }
    }
    
    private func fetchFeeds(_ showLoader: Bool = true, pageNumber page: Int = 0) {
        if showLoader == true { AppLoader.showLoader() }
        APIDataSource.feedByGroup(service: .feedsByGroup(groupId: group.groupId, page: page)) { [weak self] (feeds, paging, error) in
            if showLoader == true { AppLoader.hideLoader() }
            if let data = feeds {
                self?.paging = paging
                self?.feeds.append(contentsOf: data)
                self?.tableView.reloadData()
            } else {
                AppToast.showErrorMessage(message: error ?? someErrorMessage)
            }
            self?.loading = false
        }
    }
    // MARK: - Helper
    func loadMore() {
    
        if !loading && paging != nil && paging.currentPage < paging.lastPage {
            loading = true
            fetchFeeds(false, pageNumber: paging.currentPage + 1)
        }
    }

}
