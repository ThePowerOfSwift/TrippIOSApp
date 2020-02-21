//
//  MediaCollectionView+CollectionView.swift
//  Tripp
//
//  Created by Monu on 17/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension MediaCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: UICollectionViewDataSource Methods
    public func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return waypointMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.itemIdentifier, for: indexPath) as! MediaCollectionCell
        self.showMedia(onCell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        var assets:[MediaAsset] = []
        for media in waypointMedia {
            assets.append(media.asset())
        }
        Global.showMediaViewer(assets: assets, selectedIndex: indexPath.item)
    }
    
    //MARK: IBAction methods
    @objc func deleteMediaButtonTapped(_ sender: UIButton){
        self.waypointMedia.remove(at: sender.tag)
        if self.waypointMedia.count <= 0 {
            AppNotificationCenter.post(notification: AppNotification.mediaDeleted, withObject: nil)
        }
        else{
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.showPhotoInCenter()
        }
    }
    
    //MARK: Private Methods
    private func showMedia(onCell: MediaCollectionCell, indexPath: IndexPath){
        onCell.deleteMediaButton.tag = indexPath.item
        onCell.deleteMediaButton.addTarget(self, action: #selector(MediaCollectionView.deleteMediaButtonTapped(_:)), for: .touchUpInside)
        onCell.deleteMediaButton.isHidden = self.mediaMode == .viewer ? true : false
        onCell.imageView.image = nil
        let media = waypointMedia[indexPath.row]
        if media.type ==  MediaType.photo.rawValue{
            onCell.imageView.imageFromS3((media.sourcePath), handler: nil)
            onCell.playVideoButton.isHidden = true
        }
        else{
            //-- Fetch thumbnail from video url
            onCell.imageView.videoThumbnail(url: Utils.videoURL(fromName: media.sourcePath), handler: nil)
            onCell.playVideoButton.isHidden = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.showPhotoInCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.showPhotoInCenter()
        }
    }
    
    func showPhotoInCenter(){
        self.collectionView.setContentOffset(CGPoint(x: round(self.collectionView.contentOffset.x/258)*258, y: 0), animated: true)
    }
    
}
