//
//  TutorialRoutesViewController.swift
//  Tripp
//
//  Created by Monu on 03/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TutorialRoutesViewController: TutorialBaseViewController {
    
    
    @IBOutlet weak var popUpView: UIView!

    
    //MARK: UIViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: Private Methods
    private func setupView(){
        
        

//        self.popUpView.layer.cornerRadius = self.popUpView.frame.width/4.0
        self.popUpView.layer.cornerRadius = 12.0
        self.popUpView.clipsToBounds = true
        self.popUpView.layer.masksToBounds = false
        self.popUpView.layer.shadowColor = UIColor.tutorialPopUpshadow().cgColor
        self.popUpView.layer.shadowOpacity = 0.45
        self.popUpView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.popUpView.layer.shadowRadius = 1
        
        self.popUpView.layer.shadowPath = UIBezierPath(rect: popUpView.bounds).cgPath
        self.popUpView.layer.shouldRasterize = true
        
        self.setTitleAttributedText(text: routeMainPopupTitle, boldTexts: [""])
    }
}
