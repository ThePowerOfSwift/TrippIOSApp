//
//  FilterViewCell.swift
//  Tripp
//
//  Created by Monu on 10/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class FilterViewCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var textLabel: CharacterSpaceLabel!
    
    //MARK: Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    public func setupCell(filter: RouteFilter){
        self.colorView.backgroundColor = filter.color
        self.logoImageView.image = UIImage(named: filter.logo)
        self.textLabel.text = filter.title
        self.selectedImage.image = filter.isSelected ? UIImage(named: icSelectedFilter) : UIImage(named: icUnSelectedFilter)
        
    }
    
}
