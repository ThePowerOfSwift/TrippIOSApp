//
//  CreateGroup+UploadImage.swift
//  Tripp
//
//  Created by Bharat Lal on 01/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension CreateGroupImageViewController{
    // MARK: - Image Picker Delegate
    public func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeImage as String{
            // The info dictionary contains multiple representations of the image, and this uses the original.
            
            dismiss(animated: false, completion: {
                Utils.mainQueue {
                    AppLoader.showLoader()
                    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
                        self.changeImageButton.setImage(editedImage, for: .normal)
                    }
                    else{
                        self.changeImageButton.setImage(info[UIImagePickerControllerOriginalImage] as? UIImage, for: .normal)
                    }
                    
                    self.uploadToS3()
                }
            })
            
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    func uploadToS3(){
        Utils.uploadGroupImageOnS3(image: self.changeImageButton.currentImage!, completion: {[weak self] (name, error) in
            AppLoader.hideLoader()
            if let imageName = name{
               self?.delegate?.group.image = imageName
                self?.placeHolderImage.isHidden = true
                self?.updateImageButton.isHidden = false
            }else{
                
                AppToast.showErrorMessage(message: error!)
            }
            
        })
    }
}
