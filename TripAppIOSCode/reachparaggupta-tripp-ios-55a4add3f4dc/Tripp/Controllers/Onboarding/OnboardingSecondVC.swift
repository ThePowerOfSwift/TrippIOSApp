//
//  OnboardingSecondVC.swift
//  Tripp
//
//  Created by Monu on 16/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class OnboardingSecondVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Private methods
    private func setupView(){
        self.titleLabel.setTitle(title: onBoardingSecondTitle, subTitle: onBoardingSecondSubTitle)
    }

}
