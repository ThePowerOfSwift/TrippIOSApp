//
//  SignUpEditPhotoViewController.swift
//  Tripp
//
//  Created by Monu on 19/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import MobileCoreServices

class SignUpEditPhotoViewController: SignUpProcessBaseVC {
    
    var profile: Profile!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction Methods
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.pushAddVehical(profile: self.profile)
    }
    
    @IBAction func editImageButtonTapped(_ sender: Any) {
        openImagePickerController(sender: sender as! UIButton)
    }
    
    // MARK: - Image Picker Delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeImage as String{
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
                self.profile.image = editedImage
            }
            else{
                self.profile.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            dismiss(animated: false, completion: {
                self.profileImageView.image = self.profile.image
            })
            
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    
    /**
     * @method setupView
     * @discussion Setup view UI.
     */
    private func setupView(){
        self.skipButton.titleLabel?.attributedText = String.createAttributedString(text: (self.skipButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
        self.nextButton.titleLabel?.attributedText = String.createAttributedString(text: (self.nextButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
        
        //self.fullNameLabel.addCharacterSpacing(spacing: 0.8, attributedText: self.fullNameLabel.attributedText!)
        self.fullNameLabel.addCharactersSpacing(spacing: 0.8, text: self.profile.fullName)
        
        self.profileImageView.image = self.profile.image
        
        self.addSubTitle()
    }
    
    /**
     * @method addSubTitle
     * @discussion Setup titel and subtitle content.
     */
    private func addSubTitle(){
        let titel = String.createAttributedString(text: selectPhotoMessage, font: UIFont.openSensRegular(size: 24), color: UIColor.onboardingTitleColor(), spacing: -0.3)
        let subTitel = String.createAttributedString(text: tapNextMessage, font: UIFont.openSensLight(size: 24), color: UIColor.onboardingTitleColor(), spacing: -0.3)
        
        let attrubutedString = NSMutableAttributedString()
        attrubutedString.append(titel)
        attrubutedString.append(subTitel)
        
        self.subTitleLabel.attributedText = attrubutedString as NSAttributedString
    }

}
