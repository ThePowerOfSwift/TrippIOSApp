//
//  SettingMenuCell.swift
//  Tripp
//
//  Created by Monu on 23/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SettingMenuCell: UITableViewCell {

    @IBOutlet weak var nameLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static var identifier: String {
        return String(describing: self)
    }
    
}
