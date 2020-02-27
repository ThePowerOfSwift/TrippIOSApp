//
//  RouteDetailPopupView.swift
//  Tripp
//
//  Created by Bharat Lal on 06/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
enum PopupActionType {
    case share
    case addToWishlist
    case viewMore
}
typealias RouteDetailPopupHandler = (_ action: PopupActionType) -> ()
class RouteDetailPopupView: AlertBaseView {

    var route: Route!
    var actionHandler: RouteDetailPopupHandler?
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var addToMyTripButton: UIButton!
    @IBOutlet weak var routeImageIcon: UIImageView!
    @IBOutlet weak var routeName: CharacterSpaceLabel!
    @IBOutlet weak var routeDate: CharacterSpaceLabel!
    @IBOutlet weak var totalTime: CharacterSpaceLabel!
    @IBOutlet weak var totalDistance: CharacterSpaceLabel!
    @IBOutlet weak var photoCount: CharacterSpaceLabel!
    @IBOutlet weak var videoCount: CharacterSpaceLabel!
    @IBOutlet weak var roadTypeLabel: CharacterSpaceLabel!
    @IBOutlet weak var roadLabel: CharacterSpaceLabel!
    @IBOutlet weak var routeLevelImageIcon: UIImageView!
    static var nibName: String {
        return String(describing: self)
    }

    /**
     Initialiser method
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /**
     Initialiser method
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    required init(_ route: Route, handler: @escaping RouteDetailPopupHandler){
        super.init(frame: .zero)
        self.route = route
        self.actionHandler = handler
        setupView()
    }
    
    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
     override func setupView() {
        view = loadViewFromXibFile(nibName: RouteDetailPopupView.nibName)
        super.setupView()
       
        self.fillViewWithRoute()
        /// Adds a shadow to our view
        self.addShadowAndCornerRadius(radius: 12.0)
        view.backgroundColor = UIColor.clear
        
    }
    func fillViewWithRoute(){
        self.routeName.text = self.route.name
        routeDate.text = route.tripDate
        totalTime.text = route.totalTime
        totalDistance.text = route.distanceInMiles
        photoCount.text = route.routeImageCount > 1 ? "\(route.routeImageCount) Photos" : "\(route.routeImageCount) Photo"
        videoCount.text = route.routeVideoCount > 1 ? "\(route.routeVideoCount) Videos" : "\(route.routeVideoCount) Video"
        roadTypeLabel.text = (route.roadLevelString() + " road").uppercased()
        routeLevelImageIcon.image = UIImage(named: route.roadLevelIcon())
        
        if !self.route.imageURL.isEmpty{
            self.routeImageIcon.imageFromS3(self.route.imageURL, handler: nil)
            self.routeImageIcon.layer.borderColor = UIColor.black.cgColor
            self.routeImageIcon.layer.borderWidth = 2.0
            self.routeImageIcon.layer.cornerRadius = 3.2
            self.routeImageIcon.layer.masksToBounds = true
        }
        if self.route.isMyWish{
            self.addToMyTripButton.isEnabled = false
        }
        
    }

    /*
    Updates constraints for the view. Specifies the height and width for the view
    */
    override func updateConstraints() {
        super.updateConstraints()

        // Popup
        addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 193))
        addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.width - 24))
        
    }
    
    //MARK: IBActions
    
    @IBAction func viewMoreTapped(_ sender: UIButton) {
        if let handler = self.actionHandler{
            handler(.viewMore)
        }
        self.hideView()
    }
    @IBAction func addToMyTrip(_ sender: UIButton) {
        if let handler = self.actionHandler{
            handler(.addToWishlist)
        }
        self.hideView()
    }
    @IBAction func shareRoute(_ sender: UIButton) {
        if let handler = self.actionHandler{
            handler(.share)
        }
        self.hideView()
    }
    

}
