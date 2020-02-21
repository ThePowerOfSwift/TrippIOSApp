//
//  MapFilterView+UICollectionView.swift
//  Tripp
//
//  Created by Bharat Lal on 13/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
extension MapFilterView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: UICollectionViewDataSource Methods
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return isTripsFilter ? 1 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if isTripsFilter{
           return self.filters.count
        }
        if section == 0{
            return self.routeTypeFilters.count
        }
        return self.filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoadTypeFilterCollectionViewCell.identifier, for: indexPath) as! RoadTypeFilterCollectionViewCell
        if indexPath.section == 1 || isTripsFilter == true{
            let filter = self.filters[indexPath.item]
            cell.setupCell(filter: filter, showColorDot: false)
            
            if !filter.logo.isEmpty && filter.logo != "IcTripFilter" {
                cell.logoImageView.image = #imageLiteral(resourceName: "IcTripFilter")
                cell.logoImageView.imageFromS3(filter.logo, handler: { (image) in
                    if let currentCell = collectionView.cellForItem(at: indexPath) as? RoadTypeFilterCollectionViewCell {
                        currentCell.logoImageView.image = image
                        currentCell.logoImageView.contentMode = .scaleAspectFill
                        currentCell.logoImageView.clipsToBounds = true
                    }
                })
            }
            
        }else{
            cell.setupCell(filter: self.routeTypeFilters[indexPath.item], showColorDot: true)
        }
        return cell
    }
    
    //MARK: UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        isTripsFilter ? tripFilterTappedAt(indexPath) : routeFilterTappedAt(indexPath)
        self.filterCollectionView.reloadData()
    }
    // headers
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v : UICollectionReusableView! = nil
        if kind == UICollectionElementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:NibIdentifier.filterHeader.rawValue, for: indexPath)
            
            let lab = v.subviews[0] as! UILabel
            lab.text = self.sectionNames[indexPath.section]
            lab.textAlignment = .center
        }
        return v
    }
    
    // Helper
    private func tripFilterTappedAt(_ indexPath: IndexPath){
        let filter = self.filters[indexPath.item]
        filter.isSelected = !filter.isSelected
        if indexPath.item == self.filters.count - 1 { // wish filter
            self.isWishFilterOn = filter.isSelected
            return
        }
            if let availableCategories = categories {
                let category = availableCategories[indexPath.item]
                filter.isSelected ? selectedCategoryIds.append("\(category.categoryId)") : selectedCategoryIds.removeObject(obj: "\(category.categoryId)")
            }
        
    }
    private func routeFilterTappedAt(_ indexPath: IndexPath){
        if indexPath.section == 1{
            let filter = self.filters[indexPath.item]
            filter.isSelected = !filter.isSelected
            
        }else{
            let filter = self.routeTypeFilters[indexPath.item]
            filter.isSelected = !filter.isSelected
        }
        self.filterSelectedAt(indexPath: indexPath)
    }
    private func filterSelectedAt(indexPath: IndexPath){
        switch indexPath.section {
        case 1:
            let filter = self.filters[indexPath.item]
            let type = RoadType(rawValue: indexPath.item + 1)!
            filter.isSelected ? selectedFilters.append(type) : selectedFilters.removeObject(obj: type)
        default:
            let filter = self.routeTypeFilters[indexPath.item]
            let type = RoadType(rawValue: indexPath.item + 5)!
            filter.isSelected ? selectedFilters.append(type) : selectedFilters.removeObject(obj: type)
        }
    }
    
}
// adjust the size of each cell, as a UICollectionViewDelegateFlowLayout
extension MapFilterView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
             return CGSize(width: Global.screenRect.size.width/2, height: 110)
        }
         return CGSize(width: Global.screenRect.size.width/2, height: 130)
    }
}
