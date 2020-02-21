//
//  GroupFeedTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 02/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class GroupFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsButton: RoundedBorderButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var routeNameLabel: CharacterSpaceLabel!
    @IBOutlet weak var routeDateLabel: CharacterSpaceLabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        detailsButton.changeBorderColor(color: .blueButtonColor(), borderRadius: 10.5)
        detailsButton.addCharacterSpace(space: -0.1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: helper
    func fillWithFeed(_ feed: FeedData){
        guard let route = feed.trip  else {
            return
        }
        routeNameLabel.text = route.name
        routeDateLabel.text = route.tripDate
        imageIcon.image = UIImage(named: tripPlaceholderIcon)
        likeButton.setTitle("\(feed.totalLikeCount)", for: .normal)
        likeButton.setTitle("\(feed.totalLikeCount)", for: .selected)
        if feed.isLiked == 1 {
            likeButton.isSelected = true
        } else {
            likeButton.isSelected = false
        }
    }


}
