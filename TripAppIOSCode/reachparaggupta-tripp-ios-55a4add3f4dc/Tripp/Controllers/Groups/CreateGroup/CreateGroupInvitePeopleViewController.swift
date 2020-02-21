//
//  CreateGroupInvitePeopleViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 01/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class CreateGroupInvitePeopleViewController: UIViewController {
     // MARK: - IBOutlet / variables
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: BorderedTextField!
    
    var members = [GroupMember]()
    var paging: Paging!
    var loading: Bool = false
    weak var delegate: CreateGroupWalkthroughViewController?
    var group: Group!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - private
    private func setupUI(){
        searchTextField.addRightImageWithImage(#imageLiteral(resourceName: "IcRightTick"))
        setupSubViews()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateGroupInvitePeopleViewController.invite), name: AppNotification.textFieldRightViewTapped, object: nil)
        if delegate == nil {
            loadData(true, pageNumber: 0) // edit mode
            addCloseButton()
        }
    }
    private func addCloseButton() {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        closeButton.backgroundColor = .clear
        closeButton.frame = CGRect(x: view.frame.size.width - 50, y: 28, width: 40, height: 40)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(CreateGroupInvitePeopleViewController.close), for: .touchUpInside)
    }
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    private func setupSubViews() {
        headerView.roundCorner([.bottomLeft, .bottomRight], radius: 12)
        tableView.roundCorner([.topLeft, .topRight], radius: 12)
        tableView.tableFooterView = UIView()
    }
    private func addMember(_ member: GroupMember) {
        members.append(member)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: members.count - 1, section: 0)], with: .top)
        tableView.endUpdates()
        if delegate == nil {
            group.updateGroupMemberCount(true) // edit mode
        }
    }
    @objc private func invite(_ sender: Notification){
        if searchTextField.isEmpty() {
            AppToast.showErrorMessage(message: "Please enter email id.")
            return
        } else if !Validation.isValidEmail(searchTextField.text!) {
            AppToast.showErrorMessage(message: emailValidationMessage)
            return
        }
        if searchTextField.text! == AppUser.currentUser().email {
            AppToast.showErrorMessage(message: "You can not invite yourself.")
            return
        }
        if members.count >= 100 {
            AppToast.showErrorMessage(message: "You can add maximum 100 members.")
            return
        }
        var groupId = 0
        if let id = delegate?.group.groupId {
            groupId = id
        } else {
            groupId = group.groupId // edit mode
            if group.totalMembers >= 100 {
                AppToast.showErrorMessage(message: "You can add maximum 100 members.")
                return
            }
        }
        view.endEditing(true)
        AppLoader.showLoader()
        APIDataSource.inviteGroupMember(service: .inviteMember(groupId: groupId, email: searchTextField.text!)) { [weak self] (member, error) in
            AppLoader.hideLoader()
            if let user = member {
                self?.addMember(user)
                self?.searchTextField.text = nil
            } else {
                AppToast.showErrorMessage(message: error!)
            }
        }
    }
    //MARK: - Private/helper
    private func loadData(_ showLoader: Bool = true, pageNumber page: Int = 0) {
        if showLoader == true { AppLoader.showLoader() }
        APIDataSource.groupMemberListing(service: .groupMemberList(groupId: group.groupId, page: page)) { [weak self] (members, page, error) in
            if showLoader == true { AppLoader.hideLoader() }
            if let allMembers = members, allMembers.count > 0 {
                self?.members.append(contentsOf: allMembers)
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
extension CreateGroupInvitePeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteGroupMemberTableViewCell", for: indexPath)
        let member = members[indexPath.row]
        cell.textLabel?.text = member.email
        return cell
    }
    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            loadMore()
        }
    }
}
