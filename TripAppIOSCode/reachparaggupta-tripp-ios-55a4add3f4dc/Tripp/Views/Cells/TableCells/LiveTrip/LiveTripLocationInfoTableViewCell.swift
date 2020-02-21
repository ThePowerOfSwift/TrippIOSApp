//
//  LiveTripLocationInfoTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 21/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class LiveTripLocationInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    
    static var identifier: String{
        get{
            return String(describing: self)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
