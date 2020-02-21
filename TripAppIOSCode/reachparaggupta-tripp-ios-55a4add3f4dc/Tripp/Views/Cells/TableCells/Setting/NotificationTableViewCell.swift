//
//  NotificationTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 16/01/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
