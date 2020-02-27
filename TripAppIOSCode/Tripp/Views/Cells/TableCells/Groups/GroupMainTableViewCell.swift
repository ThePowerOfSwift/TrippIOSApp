//
//  GroupMainTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 01/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class GroupMainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupName: CharacterSpaceLabel!
    @IBOutlet weak var groupDetail: CharacterSpaceLabel!
    @IBOutlet weak var purchaseButton: RoundedBorderButton?
    @IBOutlet weak var categoryDetails: UILabel?
    @IBOutlet weak var categoryNameTopSpace: NSLayoutConstraint!
    var isCategoryView = false
    
    static var identifier: String {
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.cornerRadius = 9.0
        mainView.clipsToBounds = true
        purchaseButton?.changeBorderColor(color: .blueButtonColor(), borderRadius: 11)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCategoryView == false {
            contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 10, 20, 10))
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
