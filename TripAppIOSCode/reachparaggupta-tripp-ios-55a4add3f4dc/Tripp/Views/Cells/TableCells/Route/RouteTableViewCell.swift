//
//  RouteTableViewCell.swift
//  Tripp
//
//  Created by Bharat Lal on 10/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsButton: RoundedBorderButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var routeNameLabel: CharacterSpaceLabel!
    @IBOutlet weak var routeDateLabel: CharacterSpaceLabel!
    @IBOutlet weak var imagesCountLabel: CharacterSpaceLabel!
    @IBOutlet weak var videosCountLabel: CharacterSpaceLabel!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.detailsButton.changeBorderColor(color: .blueButtonColor(), borderRadius: 10.5)
        self.detailsButton.addCharacterSpace(space: -0.1)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: helper
    func fillWithRoute(_ route: Route){
        routeNameLabel.text = route.name
        routeDateLabel.text = route.tripDate
        imagesCountLabel.text = (route.routeImageCount > 1 ? "\(route.routeImageCount) Photos" : "\(route.routeImageCount) Photo")
        videosCountLabel.text = (route.routeVideoCount > 1 ? "\(route.routeVideoCount) Videos" : "\(route.routeVideoCount) Video")
        imageIcon.image = UIImage(named: tripPlaceholderIcon)
    }
    
    
    //MARK:-- IBActions
    @IBAction func shareTapped(_ sender: Any) {
        showUnderDevelopmentAlert()
    }
   
    @IBAction func detailsTapped(_ sender: Any) {
        showUnderDevelopmentAlert()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageIcon.image = nil
    }
}
