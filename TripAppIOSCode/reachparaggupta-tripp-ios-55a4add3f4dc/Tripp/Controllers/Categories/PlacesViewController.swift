//
//  PlacesViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 23/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
enum PlaceViewType: Int {
    case list = 1
    case map = 2
}
class PlacesViewController: UIViewController {
    
    @IBOutlet weak var headerView: CategoryHeaderView!
    @IBOutlet weak var addToWishlistButton: RoundedBorderButton!
    var viewType: PlaceViewType = .list
    var category: PlaceCategory!
    var places = [Place]()
    
    lazy var placeListViewController: PlaceListViewController = {
        var viewController = categoriesStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.placesListView.rawValue) as! PlaceListViewController
        return viewController
    }()
    
    lazy var placeMapViewController: PlaceMapViewController = {
        var viewController = categoriesStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.placesMapView.rawValue) as! PlaceMapViewController
        return viewController
    }()
    
     //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureHeader()
        
        addToWishlistButton.addCharacterSpace(space: -0.5)
        addToWishlistButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22)
         add(asChildViewController: placeListViewController)
        places.removeAll()
        loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func add(asChildViewController viewController: UIViewController) {
        super.add(asChildViewController: viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        viewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        viewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
         self.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: 80).isActive = true
        self.view.layoutIfNeeded()
    }
    //MARK: - private
    private func configureHeader() {
        headerView.congigureViewWith(category.name, firstButtonTitle: "List view", secondButtonTile: "Map view")
        headerView.delegate = self
    }
    private func updateView() {
        if self.viewType == .map {
            remove(asChildViewController: placeListViewController)
            add(asChildViewController: placeMapViewController)
            
        } else {
            remove(asChildViewController: placeMapViewController)
            add(asChildViewController: placeListViewController)
        }
    }
    func dataLoaded(_ data: [Place]) {
        places.append(contentsOf: data)
       // tableView.reloadData()
        if viewType == .list {
            placeListViewController.tableView.reloadData()
        } else {
            placeMapViewController.dataLoaded()
        }
    }
    private func loadData() {
        AppLoader.showLoader()
        APIDataSource.fetchPlacesFromCategory(service: .places(placeCategoryId: category.categoryId)) { [weak self] (places, error) in
           AppLoader.hideLoader()
            if let allPlaces = places, allPlaces.count > 0 {
                self?.dataLoaded(allPlaces)
            }
        }
    }
    //MARK: - IBActions
    @IBAction func addAllToWishListTapped(_ sender: UIButton) {
        if category.isPurchased == 0 {
            presentCategoryIAPWith(category)
            return
        }
        AppLoader.showLoader()
        APIDataSource.addCategoryToWishList(service: .addCategoryToWishlist(categoryId: category.categoryId)) { (message, error) in
            AppLoader.hideLoader()
            if let err = error {
                AppToast.showErrorMessage(message: err)
            } else {
                AppToast.showSuccessMessage(message: message ?? "All places added to your wish list.")
            }
        }
    }
}
extension PlacesViewController: CategoryHeaderProtocol {
    func itemDidTappedAt(_ index: Int) {
        viewType = PlaceViewType(rawValue: index) ?? .list
        updateView()
    }
    
}
