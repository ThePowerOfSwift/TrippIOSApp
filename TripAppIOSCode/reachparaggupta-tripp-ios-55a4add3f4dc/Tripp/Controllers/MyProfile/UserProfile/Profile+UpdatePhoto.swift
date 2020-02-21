//
//  Profile+UpdatePhoto.swift
//  Tripp
//
//  Created by Bharat Lal on 28/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension MyProfileViewController{
    // MARK: - Image Picker Delegate
    public func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeImage as String{
            // The info dictionary contains multiple representations of the image, and this uses the original.
            AppUser.currentUser().profileImage = ""
            dismiss(animated: false, completion: {
                Utils.mainQueue {
                    AppLoader.showLoader()
                    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
//                        if imagePicker.cameraDevice == .front {
//                            self.setImageFrom(imagePicker, image: editedImage)
//                        }
                        self.profileImageButton.setImage(editedImage, for: .normal)
                    }
                    else{
                        self.profileImageButton.setImage(info[UIImagePickerControllerOriginalImage] as? UIImage, for: .normal)
                    }
                    
                    self.uploadToS3()
                }
            })
            
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    func setImageFrom(_ imagePicker: UIImagePickerController, image: UIImage) {
        if imagePicker.cameraDevice == .front {
            if let cgImage = image.cgImage {
                let flippedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
                self.profileImageButton.setImage(flippedImage, for: .normal)
            } else {
                self.profileImageButton.setImage(image, for: .normal)
            }
            
        }
        /**/
    }
    func uploadToS3(){
        Utils.uploadProfileImageOnSS3(image: self.profileImageButton.currentImage!, completion: { (name, error) in
            if let imageName = name{
                APIDataSource.updateProfile(service: .updateProfileImage(imageName: imageName), handler: { (user, error) in
                    AppLoader.hideLoader()
                    if isGuardObject(user) {
                        AppUser.currentUser().updateUser(user: user!)
                        AppToast.showSuccessMessage(message: profileImageUpdated)
                    }
                    else{
                        AppToast.showErrorMessage(message: error!)
                    }
                })
            }else{
                AppLoader.hideLoader()
                AppToast.showErrorMessage(message: error!)
            }
            
        })
    }
}
