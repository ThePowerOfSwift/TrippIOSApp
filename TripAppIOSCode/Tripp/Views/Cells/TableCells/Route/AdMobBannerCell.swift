//
//  AdMobBannerCell.swift
//  Tripp
//
//  Created by Monu on 21/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdMobBannerCell: UITableViewCell {

    @IBOutlet var bannerView: GADBannerView?
    
    static var nib:UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadBanner(){
        AdMobManager.loadInlineBanner(self.bannerView!)
    }
}
