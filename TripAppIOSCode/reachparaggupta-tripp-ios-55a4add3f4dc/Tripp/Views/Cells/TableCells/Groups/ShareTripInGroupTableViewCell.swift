//
//  ShareTripInGroupTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 06/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class ShareTripInGroupTableViewCell: UITableViewCell {
    //MARK : - IBOutlates / varaible
    @IBOutlet weak var nameLabel: CharacterSpaceLabel!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var tickIcon: UIImageView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        groupImageView.layer.cornerRadius = 9
        groupImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWith(_ group: Group) {
        nameLabel.text = group.name
        tickIcon.isHidden = !group.isSelected
    }

}
