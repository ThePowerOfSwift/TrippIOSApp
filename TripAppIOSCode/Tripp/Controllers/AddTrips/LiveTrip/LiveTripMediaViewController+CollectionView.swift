//
//  LiveTripMediaViewController+CollectionView.swift
//  Tripp
//
//  Created by Bharat Lal on 24/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension LiveTripMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PopupActionDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if let waypointMedia = self.waypoints.first?.waypointMedia {
            if parentController.fromGroups == true {
                return waypointMedia.count
            }
            return waypointMedia.count + 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveTripmediaCollectionViewCell.identifier,
                                                      for: indexPath) as! LiveTripmediaCollectionViewCell
        if parentController.fromGroups == true {
            cellForGroupView(cell, indexPath: indexPath, collectionView: collectionView)
            return cell
        }
        if indexPath.item == 0 {
            cell.mediaIconImageView.image = UIImage(named: icAddMedia)
            cell.videoIconImageView.isHidden = true
            cell.deleteMediaButton.isHidden = true
        }
        else{
            if let media = self.waypoints.first?.waypointMedia[indexPath.item - 1] {
                showMedia(cell, media: media, indexPath: indexPath, collectionView: collectionView)
                
                //Delete media button
                cell.deleteMediaButton.tag = indexPath.item
                cell.deleteMediaButton.addTarget(self, action: #selector(LiveTripMediaViewController.deleteMedia(_:)), for: .touchUpInside)
                if isEditMode == true{
                    cell.deleteMediaButton.isHidden = false
                }else{
                    cell.deleteMediaButton.isHidden = true
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if parentController.fromGroups == true {
            if let assets = self.waypoints.first?.mediaAssets() {
                Global.showMediaViewer(assets: assets, selectedIndex: indexPath.item)
            }
            return
        }
        if indexPath.item == 0{
            addMedia()
        }else{
            if let assets = self.waypoints.first?.mediaAssets() {
                Global.showMediaViewer(assets: assets, selectedIndex: indexPath.item - 1)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let size = (Global.screenRect.size.width - 69)/5
        return CGSize(width: size, height: size);
        
    }
    
    //MARK: Private / Helper
    private func showMedia(_ cell: LiveTripmediaCollectionViewCell, media: WaypointMedia , indexPath: IndexPath, collectionView: UICollectionView) {
        if media.type ==  MediaType.photo.rawValue{
            cell.mediaIconImageView.imageFromS3(media.sourcePath, handler: { (image) in
                if let currentCell = collectionView.cellForItem(at: indexPath) as? LiveTripmediaCollectionViewCell{
                    currentCell.mediaIconImageView.image = image
                }
            })
            cell.videoIconImageView.isHidden = true
        }
        else{
            cell.mediaIconImageView.videoThumbnail(url: Utils.videoURL(fromName: media.sourcePath), handler: { (image) in
                if let currentCell = collectionView.cellForItem(at: indexPath) as? LiveTripmediaCollectionViewCell{
                    currentCell.mediaIconImageView.image = image
                }
            })
            cell.videoIconImageView.isHidden = false
        }
    }
    private func cellForGroupView(_ cell: LiveTripmediaCollectionViewCell, indexPath: IndexPath, collectionView: UICollectionView) {
        if let media = self.waypoints.first?.waypointMedia[indexPath.item] {
            showMedia(cell, media: media, indexPath: indexPath, collectionView: collectionView)
            cell.deleteMediaButton.isHidden = true
        }
    }
    private func addMedia(){
        let button = UIButton()
        self.openImagePickerController(sender: button, title: openAddMediaAlertTitle, message: addMediaAlertMessage, isVideoRecorder: true, isFrontCamera: false)
    }
    @objc private func deleteMedia(_ sender: UIButton){
        mediaIndexToBeDeleted = sender.tag - 1
        showConfirmPopup()
    }
    // Show popup alert for delete media confirmtion
    private func showConfirmPopup(){
        let bundle = Bundle(for: PopupViewController.self)
        let popupVC = PopupViewController(nibName: PopupViewController.nibName, bundle: bundle)
        popupVC.view.frame = UIScreen.main.bounds
        self.addChildViewController(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        popupVC.showConfirmPopup(withImage: UIImage(named:icLaunchBackground)!, centerImageName:icNotification, title: deleteTitle, deleteMediaMessage, yesTitle, cancel: noTitle, withDelegate: self)
        
    }
    func popupActionTapped(){
        if let waypointMedia = self.waypoints.first, mediaIndexToBeDeleted != -1 {
            waypointMedia.waypointMedia.remove(at: mediaIndexToBeDeleted)
            mediaIndexToBeDeleted = -1
            self.reloadTable()
        }
    }
}
