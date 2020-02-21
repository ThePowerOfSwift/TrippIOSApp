//
//  SubscriptionCell.swift
//  Tripp
//
//  Created by Monu on 06/07/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var subscriptionButton: RoundedBorderButton?
    @IBOutlet weak var currentPlanLabel: UILabel?
    
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var amountLabel: UILabel?
    @IBOutlet weak var durationLabel: UILabel?
    @IBOutlet weak var firstDetailLabel: UILabel?
    @IBOutlet weak var secondDetailLabel: UILabel?
    @IBOutlet weak var thirdDetailLabel: UILabel?
    @IBOutlet weak var fourthDetailLabel: UILabel?
    @IBOutlet weak var thirdDotView: UIView?
    @IBOutlet weak var fourthDotView: UIView?
    @IBOutlet weak var adjustConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subscriptionButton?.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 25)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
