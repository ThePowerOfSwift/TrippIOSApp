//
//  TripMediaBaseViewController.swift
//  Tripp
//
//  Created by Monu on 24/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import RealmSwift
import MobileCoreServices
import AVFoundation

class TripMediaBaseViewController: UIViewController {

    var waypoints = List<Wayponit>()

    var assetMediaAddress = MediaAsset()
    
    //MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Image Picker Delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //-- Generate Media Assets
        var assets:[MediaAsset] = self.waypoints[picker.view.tag].mediaAssets()
        let newAssets = MediaAsset()
        newAssets.isSaveMedia = false
        newAssets.assetBucketIndex = picker.view.tag
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeImage as String{
            newAssets.mediaType = .photo
            // The info dictionary contains multiple representations of the image, and this uses the original.
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
                newAssets.image = editedImage
            }
            else{
                newAssets.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            UIImageWriteToSavedPhotosAlbum(newAssets.image!, nil, nil, nil)
        }
        else if mediaType == kUTTypeMovie as String{
            newAssets.mediaType = .video
            if let url = info[UIImagePickerControllerMediaURL] as? URL{
                if !isValidateVideoLength(info: info) {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }
                newAssets.localVideoUrl = url.absoluteString
                UISaveVideoAtPathToSavedPhotosAlbum(newAssets.localVideoUrl, nil, nil, nil)
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
        newAssets.addAddress(address: assetMediaAddress.address, city: assetMediaAddress.city, state: assetMediaAddress.state, county: assetMediaAddress.country)
        newAssets.updateLatLong(latitude: assetMediaAddress.latitude, longitude: assetMediaAddress.longitude)
        
        assets.append(newAssets)
        self.showAddMediaController(assets: assets)
    }
    
    //MARK: Video Validation
    private func isValidateVideoLength(info: [String : Any]) -> Bool {
        let outputFileURL = info[UIImagePickerControllerMediaURL] as! URL
        let asset = AVURLAsset(url: outputFileURL)
        if asset.duration.seconds > 30 {
            AppToast.showErrorMessage(message: videoLengthValidationMessage)
            return false
        }
        return true
    }
    
    //MARK: Media Add or Viewer
    private func showAddMediaController(assets: [MediaAsset]){
        Global.showMediaViewer(assets: assets, selectedIndex: assets.count-1, mode: .addMedia, onController: self) { (asset) in
            if let saveAssets = asset {
                self.saveNewAssets(asset: saveAssets, index: saveAssets.assetBucketIndex)
            }
        }
    }
    
    func saveNewAssets(asset: MediaAsset, index:Int){
        let waypoint = self.waypoints[index]
        let waypointMedia = WaypointMedia()
        waypointMedia.caption = asset.caption
        waypointMedia.sourcePath = asset.imageURL
        waypointMedia.type = asset.mediaType.rawValue
        waypointMedia.latitude = asset.latitude
        waypointMedia.longitude = asset.longitude
        waypointMedia.address = asset.address
        waypointMedia.city = asset.city
        waypointMedia.state = asset.state
        waypointMedia.country = asset.country
        waypoint.waypointMedia.append(waypointMedia)
    }

}
