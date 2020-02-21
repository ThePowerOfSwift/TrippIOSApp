//
//  SignUpSuccessViewController.swift
//  Tripp
//
//  Created by Monu on 19/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SignUpSuccessViewController: SignUpProcessBaseVC {

    var profile = Profile()
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.profile.email = "monu.rathor@appster.in"
        self.setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBAction Methods
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.pushSignUpFullName(profile: profile)
    }
    
    // MARK: - Private Methods
    
    /**
     * @method setupView
     * @discussion Setup view UI.
     */
    private func setupView(){
        self.skipButton.titleLabel?.attributedText = String.createAttributedString(text: (self.skipButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
        self.nextButton.titleLabel?.attributedText = String.createAttributedString(text: (self.nextButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
        self.titleLabel.addCharacterSpacing(spacing: 0.8, attributedText: self.titleLabel.attributedText!)
        self.subTitleLabel.addCharacterSpacing(spacing: 0.5, attributedText: self.subTitleLabel.attributedText!)
        
        self.profile.email = AppUser.currentUser().email
    }

}
