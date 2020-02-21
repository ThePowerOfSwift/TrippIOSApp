//
//  MediaViewerCell.swift
//  Tripp
//
//  Created by Monu on 17/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class MediaViewerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveMediaButton: RoundedBorderButton!
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var media: MediaAsset?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //-- Adding border on button
        self.saveMediaButton.addCharacterSpace(space: -0.7)
        //self.saveMediaButton.changeBorderColor(color: UIColor.linkColor(), borderRadius: 23.0) //xr
        self.addressView.roundedBorderWithColor(color: UIColor.white.withAlphaComponent(0.29), borderRadius: 12.0)
        self.addressView.layer.borderWidth = 0.5
    }
    
    func populateMedia(media: MediaAsset, mode:MediaMode){
        
        self.media = media
        imageView.image = nil
        self.showImage(media: media)
        self.showAddress(media)
        
        captionLabel.text = media.caption
        captionTextField.text = media.caption
        playVideoButton.isHidden = media.mediaType == .photo ? true : false
        mediaTypeLabel.text = media.mediaType == .photo ? "MEDIA TYPE: PHOTO" : "MEDIA TYPE: VIDEO"
        
        //-- Setup media mode
        if mode == .viewer{
            self.setupViewer()
        }
        else{
            self.setupAddMedia()
            self.setupSaveMediaView(isSaveMedia: media.isSaveMedia)
        }        
    }
    
    private func showAddress(_ media: MediaAsset){
        if let address = media.address{
            self.addressView.isHidden = false
            self.addressLabel.text = address
        }
        else{
            self.addressView.isHidden = true
        }
    }
    
    func showImage(media: MediaAsset){
        if media.isSaveMedia {
            if media.mediaType == .photo{
                imageView.imageFromS3(media.imageURL, handler: nil)
            }
            else{
                self.imageView.videoThumbnail(url: Utils.videoURL(fromName:  media.imageURL), handler: nil)
            }
        }
        else{
            if media.mediaType == .photo{
                imageView.image = media.image
            }
            else{
                self.imageView.videoThumbnail(url: media.localVideoUrl, handler: nil)
            }
        }
    }
    
    private func setupSaveMediaView(isSaveMedia: Bool){
        if isSaveMedia {
            self.captionTextField.isEnabled = false
            self.saveMediaButton.isHidden = true
            self.captionTextField.isHidden = (media?.caption.isEmpty)! ? true : false
        }
        else{
            self.captionTextField.isHidden = false
            self.captionTextField.isEnabled = true
            self.saveMediaButton.isHidden = false
        }
    }
    
    private func setupAddMedia(){
        self.bottomConstraint.constant = 241
        self.captionLabel.isHidden = true
        self.saveMediaButton.isHidden = false
        self.captionTextField.isHidden = false
    }
    
    private func setupViewer(){
        self.bottomConstraint.constant = 241
        self.captionLabel.isHidden = false
        self.saveMediaButton.isHidden = true
        self.captionTextField.isHidden = true
    }
    
    @IBAction func playVideoButtonTapped(sender: UIButton){
        if (self.media?.isSaveMedia)! {
            VideoManager.playVideoWithUrl(viewController: UIApplication.topViewController()!, url: Utils.videoURL(fromName:  (self.media?.imageURL)!))
        }
        else{
            VideoManager.playVideoWithUrl(viewController: UIApplication.topViewController()!, url: (self.media?.localVideoUrl)!)
        }
    }
    
}
