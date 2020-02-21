//
//  RouteWaypointCell.swift
//  Tripp
//
//  Created by Monu on 17/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RouteWaypointCell: UITableViewCell {

    @IBOutlet weak var closeExpandButton: UIButton!
    @IBOutlet weak var pointLogo: UIImageView!
    @IBOutlet weak var pointNameLabel: CharacterSpaceLabel!
    @IBOutlet weak var waypointNameLabel: CharacterSpaceLabel!
    @IBOutlet weak var waypointAddressLabel: CharacterSpaceLabel!
    @IBOutlet weak var photoCountLabel: CharacterSpaceLabel!
    @IBOutlet weak var videoCountLabel: CharacterSpaceLabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var plusButton: UIButton?
    @IBOutlet weak var addPhotoMediaButton: UIButton?
    @IBOutlet weak var noImageAndVideoLabel: UILabel?
    
    var mediaCollectionView = MediaCollectionView.initializeMedia()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populateCell(waypoint: Wayponit, indexPath: IndexPath, isShowMedia: Bool){
        self.mediaView.isHidden = !isShowMedia
        self.closeExpandButton.tag = indexPath.item
        self.plusButton?.tag = indexPath.item
        self.addPhotoMediaButton?.tag = indexPath.item
        waypointNameLabel.text = (waypoint.name.isEmpty) ? " " : waypoint.name
        waypointAddressLabel.text = waypoint.address.isEmpty ? " " : waypoint.address
        photoCountLabel.text = "\(waypoint.imagesCount) Photos"
        videoCountLabel.text = "\(waypoint.videoCount) Videos"
        if isShowMedia {
            self.closeExpandButton.setTitle(buttonCloseView, for: .normal)
            addMediaView(waypoint: waypoint)
        }
        else{
            self.closeExpandButton.setTitle(buttonExpandView, for: .normal)
        }
    }
    
    private func addMediaView(waypoint: Wayponit){
        self.mediaCollectionView.waypointMedia = waypoint.waypointMedia
        self.mediaCollectionView.frame = CGRect(x: 0, y: 0, width: Global.screenRect.size.width - 19, height: 184)
        self.mediaView.addSubview(self.mediaCollectionView)
        self.mediaCollectionView.collectionView.reloadData()
        self.addPhotoMediaButton?.isHidden = waypoint.waypointMedia.count <= 0 ? false : true
        self.noImageAndVideoLabel?.isHidden = waypoint.waypointMedia.count <= 0 ? false : true
        self.mediaCollectionView.isHidden = waypoint.waypointMedia.count <= 0 ? true : false
    }
    
    

}
