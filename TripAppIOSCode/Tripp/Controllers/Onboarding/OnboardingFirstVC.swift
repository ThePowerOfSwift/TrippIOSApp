//
//  OnboardingFirstVC.swift
//  Tripp
//
//  Created by Monu on 16/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class OnboardingFirstVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MAEK: Private methods
    private func setupView(){
        self.titleLabel.setTitle(title: onBoardingFirstTitle, subTitle: onBoardingFirstSubTitle)
    }


}
