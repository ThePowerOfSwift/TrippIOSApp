//
//  RoadTypeFilterCollectionViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 13/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RoadTypeFilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tickIcon: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var textLabel: CharacterSpaceLabel!
    @IBOutlet weak var colorView: UIView!
    
    //MARK: Life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    public func setupCell(filter: RouteFilter, showColorDot: Bool){
            self.logoImageView.image = UIImage(named: filter.logo)
        if filter.logo == icTripFilter {
            self.logoImageView.contentMode = .scaleAspectFit
        }
            self.textLabel.text = filter.title
            self.tickIcon.image = filter.isSelected ? UIImage(named: icSelectedFilter) : UIImage(named: icUnSelectedFilter)
            self.colorView.isHidden = showColorDot
            self.colorView.backgroundColor = filter.color
    }
}
