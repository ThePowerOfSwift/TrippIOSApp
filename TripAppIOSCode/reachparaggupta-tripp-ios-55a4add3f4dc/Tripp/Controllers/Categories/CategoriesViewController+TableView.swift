//
//  CategoriesViewController+TableView.swift
//  Tripp
//
//  Created by Bharat Lal on 22/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupMainTableViewCell.identifier, for: indexPath) as! GroupMainTableViewCell
        configureCellAt(indexPath, cell, tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let category = categoriesDataSource[indexPath.row]
        pushPlacesList(category)
    }
    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            loadMoreData()
        }
    }
    
    //MARK: helper
    fileprivate func configureCellAt(_ indexPath: IndexPath, _ cell: GroupMainTableViewCell, _ tableView: UITableView) {
        let category = categoriesDataSource[indexPath.row]
        cell.isCategoryView = true
        cell.groupName.text = category.name
        cell.purchaseButton?.tag = indexPath.row
        cell.purchaseButton?.addTarget(self, action: #selector(CategoriesViewController.purchaseCategoryAt(_:)), for: .touchUpInside)
        if category.isPurchased == 1 {
            cell.purchaseButton?.isHidden = true
            cell.groupDetail.isHidden = false
            if viewType == .purchased {
                cell.categoryDetails?.isHidden = false
                cell.categoryDetails?.text = category.details
                cell.categoryNameTopSpace.constant = 14
            } else {
               cell.categoryDetails?.text = nil
                cell.categoryNameTopSpace.constant = 20
            }
        } else {
            cell.purchaseButton?.isHidden = false
            cell.groupDetail.isHidden = true
            cell.categoryDetails?.isHidden = true
            cell.categoryDetails?.text = ""
            cell.categoryNameTopSpace.constant = 20
        }
        
        cell.groupImageView.imageFromS3Name(category.image, placeholder: #imageLiteral(resourceName: "IcGroupPlaceholder"))
        
    }
    @objc private func purchaseCategoryAt(_ sender: UIButton) {
        indexPathForIAP = IndexPath(row: sender.tag, section: 0)
        let category = categoriesDataSource[sender.tag]
        presentCategoryIAPWith(category)
    }
}
