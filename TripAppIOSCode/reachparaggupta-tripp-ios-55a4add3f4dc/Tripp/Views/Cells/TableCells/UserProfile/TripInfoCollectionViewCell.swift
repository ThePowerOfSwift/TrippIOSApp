//
//  TripInfoCollectionViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 27/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TripInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
}
