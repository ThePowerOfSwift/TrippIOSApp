//
//  CategoriesViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 22/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
enum CategoryViewType: Int {
    case all = 1
    case purchased = 2
}

class CategoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: CategoryHeaderView!
    var categories = [PlaceCategory]()
    var categoriesDataSource = [PlaceCategory]()
    var paging: Paging!
    var loading: Bool = false
    var viewType: CategoryViewType = .all
    var indexPathForIAP: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureHeader()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        categories.removeAll()
        loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Helper
    func loadMoreData() {
        if !loading && paging != nil  && paging.currentPage < paging.lastPage {
            loading = true
            loadData(false, pageNumber: paging.currentPage + 1)
        }
    }
    func dataLoaded(_ data: [PlaceCategory]) {
        categories.append(contentsOf: data)
        reloadCategories()
    }
    //MARK: - Private/helper
    func configureHeader() {
        headerView.congigureViewWith("Categories", firstButtonTitle: "All", secondButtonTile: "Purchased")
        headerView.isBackButtonHidden = true
        headerView.delegate = self
    }
    private func loadData(_ showLoader: Bool = true, pageNumber page: Int = 0) {
        if showLoader == true { AppLoader.showLoader() }
        APIDataSource.fetchPlacesCategories(service: .placeCategories(page: page)) { [weak self] (placeCategories, page, error) in
            if showLoader == true { AppLoader.hideLoader() }
            if let allCategories = placeCategories, allCategories.count > 0 {
                self?.paging = page
                self?.dataLoaded(allCategories)
            }
            self?.loading = false
        }
    }
    private func reloadCategories() {
        categoriesDataSource.removeAll()
        if viewType == .all {
            categoriesDataSource.append(contentsOf: categories)
        } else {
            let purchased = categories.filter( { $0.isPurchased == 1 } )
            categoriesDataSource.append(contentsOf: purchased)
        }
        tableView.reloadData()
    }
}
extension CategoriesViewController: CategoryHeaderProtocol {
    func itemDidTappedAt(_ index: Int) {
//        tableView.scrollsToTop = true
        viewType = CategoryViewType(rawValue: index) ?? .all
        reloadCategories()
        if categoriesDataSource.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            tableView.setContentOffset(.zero, animated: true)
        }
    }
}
extension CategoriesViewController: CategoryPurchaseProtocol {
    func categoryDidPurchased() {
        if let indexPath = indexPathForIAP {
            tableView.reloadRows(at: [indexPath], with: .fade)
            indexPathForIAP = nil
        }
    }
}
