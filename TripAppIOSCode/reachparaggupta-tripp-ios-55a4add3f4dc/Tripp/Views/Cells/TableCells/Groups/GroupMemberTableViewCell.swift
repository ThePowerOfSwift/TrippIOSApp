//
//  GroupMemberTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 12/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class GroupMemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: CharacterSpaceLabel!
    @IBOutlet weak var statusLabel: CharacterSpaceLabel!
    @IBOutlet weak var avtar: CircularImageView!
    
    static var identifier: String {
        return String(describing: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillDataFor(_ user: GroupMember) {
        if let name = user.fullName, name.isEmpty == false {
            emailLabel.text = name
        } else {
            emailLabel.text = user.email
        }
        statusLabel.text = MemberStatus(rawValue: user.status)?.stringValue
    }

}
