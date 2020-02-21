//
//  WishListViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 23/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class WishListViewController: UIViewController, SPSegmentControlCellStyleDelegate, SPSegmentControlDelegate, AddLocationDelegate {
    
    //MARK: IBOutlet/variables
    @IBOutlet var headerView: UIView!
    @IBOutlet var wishListTableView: UITableView!
    @IBOutlet var headerLabel: CharacterSpaceLabel!
    @IBOutlet weak var segmentedControl: SPSegmentedControl!
    @IBOutlet weak var addPointLabel: UILabel!
    @IBOutlet weak var addPointButton: UIButton!
    
    var wishListArray = [WishList]()
    var locationListArray = [LocationWish]()
    var wishPlaces = [Place]()
    var listType = WishListType.Route
    var categories = [Category]()
    var categoryNames: [String] = []
    var selectedCategory: Category?
    var categoryId = ""
    var pickerView: CustomPickerView?
    var selectedWish: WishList?
    //MARK: Local message constants
    let titleRoutes = "ROUTES"
    let titlePoints = "POINTS"
    let titlePlaces = "PLACES"
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupView()
        self.loadWishList()
        addNotificationObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper/ private
    private func addNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(WishListViewController.routeWishDeleted), name: AppNotification.deleteRouteWish, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WishListViewController.locationWishDeleted), name: AppNotification.deleteLocationWish, object: nil)
    }
    private func setupView(){
        self.wishListTableView.delegate = self
        self.wishListTableView.dataSource = self
        
        setupSegmentedControl()
        addPointLabel.isHidden = true
        addPointButton.isHidden = true
    }
    private func setupSegmentedControl(){
        segmentedControl?.layer.borderColor = UIColor.selectedTabTextColor().cgColor
        segmentedControl?.layer.borderWidth = 0.9
        segmentedControl?.backgroundColor = UIColor.black
        segmentedControl?.indicatorView.backgroundColor =  UIColor.selectedTabTextColor()
        segmentedControl?.styleDelegate = self
        segmentedControl?.delegate = self
        
        let xFirstCell = self.createCell(
            text: titleRoutes
        )
        xFirstCell.layout = .onlyText
        let xSecondCell = self.createCell(
            text: titlePoints
        )
        xSecondCell.layout = .onlyText
        let xThirdCell = self.createCell(
            text: titlePlaces
        )
        xThirdCell.layout = .onlyText
        
        for cell in [xFirstCell, xSecondCell, xThirdCell] {
            self.segmentedControl.add(cell: cell)
            
        }
        self.segmentedControl.addTarget(self, action: #selector(WishListViewController.segmentedValueChanged(_:)), for: .valueChanged)
    }
    private func createCell(text: String) -> SPSegmentedControlCell {
        let cell = SPSegmentedControlCell.init()
        cell.label.text = text
        cell.label.font = UIFont.openSensRegular(size: 13.1)
        return cell
    }
    
    @objc func showLoaderWithDelay(){
        AppLoader.showLoader()
    }
    @objc func hideLoaderWithDelay(){
        AppLoader.hideLoader()
    }
    private func reFreshListView(){
        if self.listType == .Route{
            self.setupHeaderLabel(message: "\(wishListArray.count) " + numberOfRecords)
            addPointLabel.isHidden = true
            addPointButton.isHidden = true
        }else if listType == .Location {
            self.setupHeaderLabel(message: "\(locationListArray.count) " + numberOfPoints)
            addPointLabel.isHidden = false
            addPointButton.isHidden = false
        } else {
            self.setupHeaderLabel(message: "\(wishPlaces.count) " + numberOfPlaces)
            addPointLabel.isHidden = true
            addPointButton.isHidden = true
        }
        
        self.wishListTableView.reloadData()
    }
    func fetchCategories(){
        AppLoader.showLoader()
        CategoryManager.sharedManager.fetchCategories { (categories, error) in
            AppLoader.hideLoader()
            if let _ = categories{
                self.categories = categories!
                self.categoryNames = self.categories.map( { $0.name })
                self.configureCategoryPicker()
            }
        }
    }
    private func configureCategoryPicker(){
        
        let categoryPicker = CategoryPickerView(pickerComponent: [categoryNames], frame: CGRect(x: 0, y: self.view.bounds.height-(216 + 40), width: self.view.bounds.width, height: 216+40))
        categoryPicker.delegate = self
        categoryPicker.picker.handler = { (picker, indexPath) in
            self.selectedCategory = self.categories[(indexPath?.item)!]
            self.categoryId = (self.selectedCategory?.categoryId.description)!
        }
        self.view.addSubview(categoryPicker)
    }
    func loadWishList(){
        self.perform(#selector(WishListViewController.showLoaderWithDelay), with: nil, afterDelay: 0.0) // It is blocking the swipe beghaviour of XLPagerTabStrip if shown immediately
        self.setupHeaderLabel(message: loadingWishList)
        APIDataSource.userWishList(service: .wishList) { (wishList, error) in
            
            self.perform(#selector(WishListViewController.hideLoaderWithDelay), with: nil, afterDelay: 0.0)
            guard let list = wishList else{
                self.setupHeaderLabel(message: noData)
                return
            }
            self.wishListArray = list
            self.reFreshListView()
        }
    }
    func loadLocationWishList(){
        self.setupHeaderLabel(message: loadingWishList)
        AppLoader.showLoader()
        APIDataSource.userLocationWishList(service: .locationWishList) { (wishList, error) in
            AppLoader.hideLoader()
            guard let list = wishList else{
                self.setupHeaderLabel(message: noData)
                return
            }
            self.locationListArray = list
            self.reFreshListView()
        }
    }
    func loadPlacesWishList(){
        self.setupHeaderLabel(message: loadingWishList)
        AppLoader.showLoader()
        APIDataSource.fetchPlacesWishOrCompletedList(service: .placeWishList()) { [weak self] (places, error) in
            AppLoader.hideLoader()
            guard let list = places else{
                self?.setupHeaderLabel(message: noData)
                return
            }
            self?.wishPlaces = list
            self?.reFreshListView()
        }
    }
    func locationAdded() {
        loadLocationWishList()
    }
    @objc func routeWishDeleted(){
        loadWishList()
    }
    @objc func locationWishDeleted(){
        loadLocationWishList()
    }
    func setupHeaderLabel(message: String){
        self.headerLabel.attributedText = String.createAttributedString(text: message, font: self.headerLabel.font, color: self.headerLabel.textColor, spacing: 3.0)
    }
    //MARK: IBActions
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addPointTapped(_ sender: Any) {
        pushToAddLocationWishController()
    }
    //MARK: Segmented control
    @objc func segmentedValueChanged(_ sender: SPSegmentedControl){
        if sender.selectedIndex == 0{
            self.listType = .Route
        }else if sender.selectedIndex == 1 {
            self.listType = .Location
            if locationListArray.count == 0{
                loadLocationWishList()
            }
        } else {
            self.listType = .Places
            if wishPlaces.count == 0{
                loadPlacesWishList()
            }
        }
        self.reFreshListView()
        
    }
    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.black
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.black
        }, completion: nil)
    }
    
    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.white
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.selectedTabTextColor()
        }, completion: nil)
    }
    //MARK: deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
