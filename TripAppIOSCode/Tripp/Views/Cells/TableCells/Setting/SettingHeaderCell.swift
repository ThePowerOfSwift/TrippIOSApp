//
//  SettingHeaderCell.swift
//  Tripp
//
//  Created by Monu on 23/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SettingHeaderCell: UITableViewCell {

    @IBOutlet var roundedView : UIView!
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var logo : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundedView.layer.borderWidth = 1.0
        self.roundedView.layer.borderColor = UIColor.buttonBorderColor().cgColor
        self.roundedView.layer.cornerRadius = 8.0
        self.roundedView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static var identifier: String {
        return String(describing: self)
    }
    
}
