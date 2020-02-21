//
//  WishlistTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 27/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class WishlistTableViewCell: UITableViewCell {

    @IBOutlet weak var viewButton: RoundedBorderButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var routeNameLabel: CharacterSpaceLabel!
    @IBOutlet weak var routeDateLabel: CharacterSpaceLabel!
    @IBOutlet weak var imagesCountLabel: CharacterSpaceLabel!
    @IBOutlet weak var videosCountLabel: CharacterSpaceLabel!
    @IBOutlet weak var imageCountIcon: UIImageView!
    @IBOutlet weak var videoCountIcon: UIImageView!
    @IBOutlet weak var shareIconTrailingSpace: NSLayoutConstraint!
    
    static var identifier: String{
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewButton.changeBorderColor(color: .blueButtonColor(), borderRadius: 10.5)
        self.viewButton.addCharacterSpace(space: -0.1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateWith(_ wish: WishList){
        self.routeNameLabel.text = wish.trip?.name
        if wish.trip?.isMyTrip == true{
            self.plusButton.isEnabled = false
        }else{
             self.plusButton.isEnabled = true
        }
        self.routeDateLabel.text = wish.trip?.createdAt.convertFormatOfDate(AppDateFormat.sortDate)
        self.imagesCountLabel.text = wish.imageCount > 1 ? "\(wish.imageCount) Photos" : "\(wish.imageCount) Photo"
        self.videosCountLabel.text = wish.videoCount > 1 ? "\(wish.videoCount) Videos" : "\(wish.videoCount) Video"
        if let imageURL = wish.trip?.primaryImage?.sourcePath{
            self.imageIcon.imageFromS3(imageURL, handler: nil)
        }
        self.imagesCountLabel.isHidden = false
        self.videosCountLabel.isHidden = false
        self.imageCountIcon.isHidden = false
        self.videoCountIcon.isHidden = false
        self.plusButton.isHidden = false
        self.shareIconTrailingSpace.constant = 19
        
    }
    func populateWithLocation(_ wish: LocationWish){
        self.routeNameLabel.text = wish.name == nil ? "" : wish.name
        let date = wish.createdAt == nil ? "" : wish.createdAt!
        self.routeDateLabel.text = date.convertFormatOfDate(AppDateFormat.sortDate)
        updateControlsState()
    }
    fileprivate func updateControlsState() {
        self.imagesCountLabel.isHidden = true
        self.videosCountLabel.isHidden = true
        self.imageCountIcon.isHidden = true
        self.videoCountIcon.isHidden = true
        self.plusButton.isHidden = true
        self.shareIconTrailingSpace.constant = -30
    }
    
    func populateWithPlace(_ wish: Place){
        self.routeNameLabel.text = wish.name
        let date = wish.createdAt == nil ? "" : wish.createdAt!
        self.routeDateLabel.text = date.convertFormatOfDate(AppDateFormat.sortDate)
        if let imageURL = wish.primaryImage {
            self.imageIcon.imageFromS3(imageURL, handler: nil)
        }
        updateControlsState()
    }
    
}
