//
//  LiveTripMediaTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 21/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class LiveTripMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var photoCountLabel: CharacterSpaceLabel!
    @IBOutlet weak var videoCountLabel: CharacterSpaceLabel!
    @IBOutlet weak var expandCollapseButton: UIButton!
    
    var isExpanded: Bool = false
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
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        mediaCollectionView.delegate = dataSourceDelegate
        mediaCollectionView.dataSource = dataSourceDelegate
        mediaCollectionView.tag = row
        mediaCollectionView.reloadData()
    }
}
