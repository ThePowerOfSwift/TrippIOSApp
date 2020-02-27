//
//  AddTripWaypointViewController.swift
//  Tripp
//
//  Created by Monu on 21/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import RealmSwift
import MobileCoreServices
import AVFoundation

protocol TripWaypointDelegate: class {
        
    func moveWaypoint(from:Int, to:Int)
    func deleteWaypoint(atIndex: Int)
}

class TripWaypointViewController: TripMediaBaseViewController {

    @IBOutlet weak var addNewPoint: RoundedBorderButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var waypointTableView: UITableView!
    @IBOutlet weak var openCloseButton: UIButton!
    @IBOutlet weak var waypointCountLabel: UILabel!
    @IBOutlet weak var messageLabel: CharacterSpaceLabel!
    @IBOutlet weak var waypointTitleLabel: CharacterSpaceLabel!
    @IBOutlet weak var savePointButton: RoundedButton!
    @IBOutlet weak var finishRouteButton: RoundedButton!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var categoryNameTextField: UITextField!
    weak var delegate: TripWaypointDelegate?
    
    var isSwipeToDelete = true
    //var waypoints = List<Wayponit>()
    
    var expandedIndexPath: IndexPath?
    var selectWaypoint: Wayponit?
    var tripId = 0
    var groupId = 0
    var categories = [Category]()
    var groups = [Group]()
    var selectedGroup: Group?
    var categoryNames: [String] = []
    var selectedCategory: Category?
    var originalCategoryId: Int? = nil
    
    //MARK: UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.fetchGroups()
        self.setupGroupTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func saveNewAssets(asset: MediaAsset, index: Int) {
        super.saveNewAssets(asset: asset, index: index)
        self.displayInitialPoint()
        self.savePointButton.isHidden = self.selectWaypoint != nil ? false : true
    }
    
    //MARK: Private methods
    
    private func fetchGroups(){
        AppLoader.showLoader()
        APIDataSource.groupListing(service: .groupList(page: 1)) { [weak self] (groups, paging, message) in
            AppLoader.hideLoader()
            if let groupsResponse = groups{
                self?.groups = groupsResponse
                self?.setupGroupTextField()
                if let groupId = self?.groupId, groupId > 0 {
                    self?.selectedGroup = self?.groups.filter({$0.groupId == groupId}).first
                    self?.groupNameTextField.text = self?.selectedGroup?.name
                }
            }
        }
    }
    
    private func setupGroupTextField() {
        let groupNames = self.groups.compactMap({$0.name})
        self.groupNameTextField.inputView = CustomPickerView(pickerComponent: [groupNames], completion: { (_, indexPath) in
            guard let index = indexPath?.row else { return }
            self.groupNameTextField.text = groupNames[index]
            self.selectedGroup = self.groups[index]
        })
    }
    
    private func setupView(){
        self.savePointButton.isHidden = true
        self.finishRouteButton.isHidden = true
        self.displayInitialPoint()
        self.enableLongPressOnTableView()
        self.messageLabel.text = initialWaypointMessage
        self.addNewPoint.addCharacterSpace(space: -0.5)
        self.addNewPoint.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 24.5)
        NotificationCenter.default.addObserver(self, selector: #selector(TripWaypointViewController.mediaDeleted), name: AppNotification.mediaDeleted, object: nil)
    }
    
    //-- Update data according to waypoints selected.
    func saveWaypoint(waypoints: List<Wayponit>){
        self.waypoints = waypoints
        displayInitialPoint()
    }
    
    func selectWaypoint(waypoint: Wayponit){
        self.savePointButton.isHidden = false
        self.finishRouteButton.isHidden = true
        self.selectWaypoint = waypoint
        self.messageLabel.text = self.selectWaypoint?.address
        self.waypointTitleLabel.text = waypoints.count <= 0 ? waypointTitleMessage : ""
        if let parentController = self.parent as? AddWaypointToTripViewController{
            self.originalCategoryId = parentController.trip?.categoryId.value
        }
    }
    
    //-- Display initial information
     func displayInitialPoint(){
        self.finishRouteButton.isHidden = true
        self.savePointButton.isHidden = true
        self.waypointTitleLabel.text = ""
        self.waypointCountLabel.text = "\(waypoints.count)"
        self.updateView()
        if let parentController = self.parent as? AddWaypointToTripViewController{
            parentController.trip?.categoryName(handler: { categoryName in
                self.categoryNameTextField.text = categoryName
            })
        }
        self.waypointTableView.reloadData()
    }
    
    private func updateView(){
        if self.waypoints.count <= 0 {
            self.messageLabel.text = initialWaypointMessage
        }
        else if waypoints.count == 1 {
            self.messageLabel.text = addNextWaypointMessage
        }
        else{
            self.messageLabel.text = addMoreWaypoints
            self.finishRouteButton.isHidden = false
        }
    }
    @objc internal func categoryPicker(){
        
        categoryNameTextField.inputView = CustomPickerView(pickerComponent: [categoryNames], completion: { (picker, indexPath) in
            
            self.selectedCategory = self.categories[(indexPath?.item)!]
            self.categoryNameTextField.text = self.selectedCategory!.name
            if let parentController = self.parent as? AddWaypointToTripViewController{
                parentController.trip?.categoryId.value = self.selectedCategory?.categoryId
            }
        })
        self.categoryNameTextField.becomeFirstResponder()
    }
    //MARK: IBAction methods
    @IBAction func uploadPhotoTap(_ sender: UIButton) {
        let waypoint = self.waypoints[sender.tag]
        self.openImagePickerController(sender: sender, title: openAddMediaAlertTitle, message: addMediaAlertMessage, isVideoRecorder: true, isFrontCamera: false, savedVideo:waypoint.videoCount, savedPhoto: waypoint.imagesCount)
    }
    @IBAction func editCategoryTapped(_ sender: Any) {
        if let parentController = self.parent as? AddWaypointToTripViewController, parentController.trip?.categoryId.value == nil {
           loadAndShowCategories()
        }else{
            self.openActionSheet()
        }
    }
    
    @IBAction func editGroupTapped(_ sender: Any) {
        self.groupNameTextField.becomeFirstResponder()
    }
    
    func loadAndShowCategories(){
        AppLoader.showLoader()
        CategoryManager.sharedManager.fetchCategories { (categories, error) in
            AppLoader.hideLoader()
            if let categoriesArray = categories{
                self.categories = categoriesArray
                self.categoryNames = self.categories.map( { $0.name })
                Utils.mainQueue {
                    self.perform(#selector(TripWaypointViewController.categoryPicker), with: nil, afterDelay: 0.1)
                }
                
            }
        }
    }
    //-- Open location alert action
    func openActionSheet(){
        let alertController = UIAlertController(title: nil, message: chooseOption, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        
        let editAction = UIAlertAction(title: editCategory, style: .default) { (camera) -> Void in
            self.loadAndShowCategories()
        }
        
        let deleteAction = UIAlertAction(title: deleteCategory, style: .destructive) { (camera) -> Void in
            if let parentController = self.parent as? AddWaypointToTripViewController{
                parentController.trip?.categoryId.value = nil
                self.categoryNameTextField.text = noCategory
            }
        }
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //-- Media Deleted from Media Collection class
    @objc func mediaDeleted(){
        self.waypointTableView.reloadData()
    }
    
    //-- Remove notification from current class
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
