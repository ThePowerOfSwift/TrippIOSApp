//
//  WaypointMedia+Helper.swift
//  Tripp
//
//  Created by Monu on 31/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation


extension WaypointMedia{
    
    func asset() -> MediaAsset{
        let asset = MediaAsset()
        asset.mediaType = MediaType(rawValue: self.type)!
        asset.imageURL = self.sourcePath
        asset.caption = self.caption
        return asset
    }
    
    func saveAsset(waypointId: Int, tripId:Int){
        AppLoader.showLoader()
        APIDataSource.addNewAsset(caption: self.caption, sourcePath: self.sourcePath, type: self.type, waypointId: waypointId, tripId: tripId) { (message, error) in
            AppLoader.hideLoader()
            if error != nil {
                AppToast.showErrorMessage(message: error!)
            }
            else{
                AppToast.showSuccessMessage(message: message!)
            }
        }
    }
    
    func deleteAsset(completion: @escaping (_ message: String?, _ error: String?) -> ()){
        AppLoader.showLoader()
        APIDataSource.deleteMediaAsset(mediaId: self.mediaId) { (message, error) in
            AppLoader.hideLoader()
            completion(message, error)
        }
    }
    
    //MARK: Copy of a object
    override func copy() -> Any{
        let copy = WaypointMedia()
        copy.mediaId = self.mediaId
        copy.type = self.type
        copy.caption = self.caption
        copy.sourcePath = self.sourcePath
        copy.createdAt = self.createdAt
        return copy
    }
    
}
