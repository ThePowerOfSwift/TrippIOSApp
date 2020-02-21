//
//  PlaceDetailsViewController+UICollectionView.swift
//  Tripp
//
//  Created by Bharat Lal on 26/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

extension PlaceDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return place.images.count == 0 ? 1 : place.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceImageCell", for: indexPath)
        let image: String?
        if place.images.count == 0 {
            image = place.primaryImage
        } else {
            image = place.images[indexPath.item].image
        }
        
        if let imageView = cell.viewWithTag(1001) as? UIImageView {
            if let url = image, url.isEmpty == false{
                imageView.imageFromS3(url, handler: { (image) in
                     imageView.image = image
                })
            } else {
                imageView.image = #imageLiteral(resourceName: "tripImagesCount")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

