//
//  SignUpAddPhotoViewController.swift
//  Tripp
//
//  Created by Monu on 19/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import MobileCoreServices

class SignUpAddPhotoViewController: SignUpProcessBaseVC {

    var profile: Profile!
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var profilePhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction Methods
    @IBAction func openImagePickerTapped(_ sender: Any) {
        openImagePickerController(sender: sender as! UIButton)
    }
    
    
    // MARK: - Image Picker Delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == kUTTypeImage as String{
            // The info dictionary contains multiple representations of the image, and this uses the original.
            
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
                self.profile.image = editedImage
            }
            else{
                self.profile.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            
            dismiss(animated: false, completion: {
                self.showEditPhotoScreen()
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
        self.subTitleLabel.addCharacterSpacing(spacing: 0.5, attributedText: self.subTitleLabel.attributedText!)
        self.fullNameLabel.attributedText = String.createAttributedString(text: self.profile.fullName, font: UIFont.openSensRegular(size: 30), color: UIColor.white, spacing: 0.8)
    }
    
    private func showEditPhotoScreen(){
        self.pushEditProfilePhotoWith(profile: self.profile)
    }

}
