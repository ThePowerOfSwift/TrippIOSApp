//
//  MediaViewerViewController+CollectionView.swift
//  Tripp
//
//  Created by Monu on 17/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit


extension MediaViewerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaViewerCell.itemIdentifier, for: indexPath) as! MediaViewerCell
        cell.populateMedia(media: assets[indexPath.item], mode: self.mediaMode)
        cell.tag = indexPath.item
        cell.captionTextField.tag = indexPath.item
        cell.saveMediaButton.tag = indexPath.item
        cell.captionTextField.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if let visibleCell = self.collectionView.visibleCells.first{
            self.titleCountLabel.text = "\(visibleCell.tag+1)/\(assets.count)"
        }
    }
}

// adjust the size of each cell, as a UICollectionViewDelegateFlowLayout
extension MediaViewerViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Global.screenRect.size.width, height: Global.screenRect.size.height-66)
    }
    
}

extension MediaViewerViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let media = self.assets[textField.tag]
        media.caption = textField.text!
        self.collectionView.reloadData()
    }
    
}
