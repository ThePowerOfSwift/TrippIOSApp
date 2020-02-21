//
//  LiveTripmediaCollectionViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 24/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class LiveTripmediaCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String{
        return String(describing: self)
    }
    @IBOutlet weak var mediaIconImageView: UIImageView!
    
    @IBOutlet weak var videoIconImageView: UIImageView!
    
    @IBOutlet weak var deleteMediaButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaIconImageView.image = nil
    }
}
