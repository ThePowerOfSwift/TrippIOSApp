//
//  UIViewController+UIImagePickerController.swift
//  Tripp
//
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import AVFoundation
import MobileCoreServices
import UIKit

let maximumVideo = 3
let maximumPhotos = 10

extension UIViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     An IBAction which opens UIImagePickerController. You just need to connect it to a UIButton in your User Interface. all the hassel will be handled on by its own. you can also call this function programatically of course
     
     - parameter sender: UIButton in user interface which will fire this action
     */
    func openImagePickerController(sender: UIButton, title:String = "Choose a picture", message:String?=nil, isVideoRecorder:Bool = false, isFrontCamera:Bool = true, savedVideo:Int = 0, savedPhoto:Int=0) {
        
        DLog(message: "button tag is \(sender.tag)" as AnyObject)
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if status == AVAuthorizationStatus.denied {
            let alertController = UIAlertController(title: NSLocalizedString(unauthorizedAccessImagePickerMessage, comment: unauthorizedAccessImagePickerMessage), message: NSLocalizedString(changeSettingMessage, comment: changeSettingMessage), preferredStyle: .alert)
            let okAction = UIAlertAction(title: okayButtonTitle, style: .default, handler: { (UIAlertAction) -> Void in
                guard let url = NSURL(string: UIApplicationOpenSettingsURLString) else {return}
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString(cancel, comment: cancel), style: .cancel, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            presentAlert(sender: alertController)
        }
        else {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
            alertController.popoverPresentationController?.sourceRect = sender.bounds
            alertController.popoverPresentationController?.sourceView = sender
            let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
            presentAlert(sender: alertController)
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.view.tag = sender.tag
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.popover
            imagePickerController.popoverPresentationController?.sourceView = sender
            imagePickerController.popoverPresentationController?.sourceRect = sender.bounds
            
            let camera = UIAlertAction(title: takeANewPhotoMessage, style: .default) { (camera) -> Void in
                if savedPhoto >= maximumPhotos && savedPhoto != 0{
                    AppToast.showErrorMessage(message: photoUploadValidationMessage)
                    return
                }
                imagePickerController.mediaTypes = [kUTTypeImage as String]
                imagePickerController.sourceType = .camera
                if isFrontCamera {
                    //comment following 2 lines for rear camera
                    imagePickerController.cameraDevice = .front
                    //imagePickerController.cameraViewTransform = imagePickerController.cameraViewTransform.scaledBy(x: -1, y: 1)
                }
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
            let video = UIAlertAction(title: takeANewVideoMessage, style: .default) { (video) -> Void in
                if savedVideo >= maximumVideo && savedVideo != 0{
                    AppToast.showErrorMessage(message: videoUploadValodationMessage)
                    return
                }
                imagePickerController.mediaTypes = [kUTTypeMovie as String]
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
            let photoLibrary = UIAlertAction(title: pickFromPhotoLibraryMessage, style: .default) { (Photolibrary) -> Void in
                if savedPhoto >= maximumPhotos && savedPhoto != 0{
                    AppToast.showErrorMessage(message: photoUploadValidationMessage)
                    return
                }
                imagePickerController.mediaTypes = [kUTTypeImage as String]
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                alertController.addAction(camera)
                if isVideoRecorder {
                    alertController.addAction(video)
                }
            }
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                alertController.addAction(photoLibrary)
            }
            
            alertController.addAction(cancelAction)
            
        }
    }
    
    private func presentAlert(sender: UIAlertController) {
        present(sender, animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
