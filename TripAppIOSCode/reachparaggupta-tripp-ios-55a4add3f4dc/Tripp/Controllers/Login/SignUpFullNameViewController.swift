//
//  SignUpFullNameViewController.swift
//  Tripp
//
//  Created by Monu on 19/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SignUpFullNameViewController: SignUpProcessBaseVC {

    var profile:Profile?
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    
    /**
     * @method setupView
     * @discussion Setup view UI.
     */
    private func setupView(){
        self.skipButton.titleLabel?.attributedText = String.createAttributedString(text: (self.skipButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
        self.nextButton.titleLabel?.attributedText = String.createAttributedString(text: (self.nextButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
        self.subTitleLabel.addCharacterSpacing(spacing: 0.5, attributedText: self.subTitleLabel.attributedText!)
        self.fullNameTextField.attributedPlaceholder = String.createAttributedString(text: self.fullNameTextField.placeholder!, font: UIFont.openSensRegular(size: 30), color: UIColor.white, spacing: 0.8)
    }
    
    //MARK: - IBAction Methods
    @IBAction func nextButtonTapped(_ sender: Any) {
        if self.fullNameTextField.isEmpty() {
            AppToast.showErrorMessage(message: fullNameEmptyValidation)
        }
        else if !Validation.isAlphaNumeric(text: self.fullNameTextField.text!){
            AppToast.showErrorMessage(message: fullNameValidation)
        }
        else{
            self.profile?.fullName = self.fullNameTextField.text!
            self.pushAddProfilePhotoWith(profile: self.profile!)
        }
    }
    

}
