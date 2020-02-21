//
//  RouteDetailsTopBar.swift
//  Tripp
//
//  Created by Monu on 10/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RouteDetailsTopBar: UIView {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var addToWishListButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK: Initialize filter view
    class func initializeTopBar() -> RouteDetailsTopBar{
        let topBar = RouteDetailsTopBar.fromNib()
        topBar.frame = UIScreen.main.bounds
        let y = Devices.deviceName() == Model.iPhoneX.rawValue ? (UIApplication.shared.statusBarFrame.height - 20.0) : 0
        topBar.frame.origin.y = y
        topBar.frame.size.height = 90
        return topBar
    }
    
    //MARK: Helper
    class func fromNib<T : RouteDetailsTopBar>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    //MARK: Life Cycle
    override func awakeFromNib(){
        self.setupView()
    }
    
    //MARK: Private Methods
    private func setupView(){
        addBottomRoundedCorner()
    }
    
    private func addBottomRoundedCorner(){
        self.roundCorner([.bottomLeft, .bottomRight], radius: 10.0)
    }
    
}
