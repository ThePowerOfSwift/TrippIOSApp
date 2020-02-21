//
//  TutorialRoutesFilterVC.swift
//  Tripp
//
//  Created by Monu on 04/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TutorialRoutesFilterVC: TutorialBaseViewController {
    
    let activeImage:UIImage = UIImage(named: "selectedPageControl")!
    let inactiveImage:UIImage = UIImage(named: "unselectedPageControl")!
    
    //MARK: UIViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private Methods
    private func setupView(){
    
        self.setTitleAttributedText(text: tutorialFilterTitle, boldTexts: [tutorialTheFilter])
    }
    
}
