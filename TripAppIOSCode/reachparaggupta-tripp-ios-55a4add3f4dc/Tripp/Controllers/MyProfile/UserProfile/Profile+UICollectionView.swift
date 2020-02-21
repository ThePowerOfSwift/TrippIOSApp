//
//  Profile+UICollectionView.swift
//  Tripp
//
//  Created by Bharat Lal on 27/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension MyProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return tripInformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellData = tripInformations[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripInfoCollectionViewCell.identifier,
                                                      for: indexPath as IndexPath) as! TripInfoCollectionViewCell
        
        cell.iconImageView.image = UIImage(named: cellData.logo)
        cell.numberLabel.text = cellData.number
        cell.infoLabel.text = cellData.info
        
        return cell
    }
    
    //Scroll view Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageStackView.insertArrangedSubview(activeImageView, at: index)
    }
}

// adjust the size of each cell, as a UICollectionViewDelegateFlowLayout
extension MyProfileViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Global.screenRect.size.width/3, height: collectionView.frame.size.height)
    }
}

struct TripInfo {
    static let statesTraveled = "Number of States travelled"
    static let countriesTraveled = "Number of countries travelled"
    static let easyRoadsTraveled = "Number of \'Easy\' roads covered"
    static let intermediateRoadsTraveled = "Number of \'Intermediate\' roads covered"
    static let difficultRoadsTraveled = "Number of \'Difficult\' roads covered"
    static let proRoadsTraveled = "Number of \'Advanced\' roads covered"
    static let roadMilesTraveled = "Miles traveled on Road trips"
    static let aerialMilesTraveled = "Miles traveled on Aerial trips"
    static let seaMilesTraveled = "Miles traveled in Sea trips"
    static let milesTraveled = "Miles traveled in "
}

