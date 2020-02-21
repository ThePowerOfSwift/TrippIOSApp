//
//  RouteFilterView+CollectionView.swift
//  Tripp
//
//  Created by Monu on 10/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

class RouteFilter {
    var color: UIColor?
    var isSelected: Bool = false
    var title: String = ""
    var logo: String = ""
    var value: String = ""
    
    required init(color: UIColor, isSelected: Bool, title: String, logo: String, value:String = ""){
        self.color = color
        self.isSelected = isSelected
        self.title = title
        self.logo = logo
        self.value = value
    }
}

extension RouteFilterView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: UICollectionViewDataSource Methods
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterViewCell.identifier, for: indexPath) as! FilterViewCell
        cell.setupCell(filter: self.filters[indexPath.item])
        return cell
    }
    
    //MARK: UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        //-- reset all filters
        for filter in self.filters {
            filter.isSelected = false
        }
        
        let filter = self.filters[indexPath.item]
        filter.isSelected = true
        self.filterCollectionView.reloadData()
        self.selectedFilters()
    }
    
}
