//
//  AlbumMediaCell.swift
//  Tripp
//
//  Created by Monu on 13/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AlbumMediaCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
