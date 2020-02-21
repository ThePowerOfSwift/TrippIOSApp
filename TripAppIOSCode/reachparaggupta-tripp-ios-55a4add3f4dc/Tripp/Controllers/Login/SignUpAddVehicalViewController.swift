//
//  SignUpAddVehicalViewController.swift
//  Tripp
//
//  Created by Monu on 20/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SignUpAddVehicalViewController: SignUpProcessBaseVC {

    var profile:Profile!
    var isEditMode = false
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var typeTextField: BottomBorderTextField!
    @IBOutlet weak var makeTextField: BottomBorderTextField!
    @IBOutlet weak var modelTextField: BottomBorderTextField!
    @IBOutlet weak var yearTextField: BottomBorderTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var saveButtonImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction Methods
    @IBAction func saveButtonTapped(_ sender: Any) {
        if isValidateTextFields(showAlert: true){
            if self.isEditMode{
                self.updateVehicle()
            }else{
                self.updateProfile()
            }
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any?) {
        if isValidateTextFields(showAlert: false) {
            self.saveButton.isHidden = false
            self.saveButtonImage.isHidden = false
        }
        else{
            self.saveButton.isHidden = true
            self.saveButtonImage.isHidden = true
        }
    }
    // MARK: - Private Methods
    
    /**
     * @method setupView
     * @discussion Setup view UI.
     */
    private func setupView(){
        self.skipButton.titleLabel?.attributedText = String.createAttributedString(text: (self.skipButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
        self.saveButton.titleLabel?.attributedText = String.createAttributedString(text: (self.saveButton.titleLabel?.text!)!, font: UIFont.openSensRegular(size: 18), color: UIColor.white, spacing: 2.2)
        
        self.fullNameLabel.addCharactersSpacing(spacing: 0.8, text: self.profile.fullName)
        self.subTitleLabel.addCharacterSpacing(spacing: -0.4, attributedText: self.subTitleLabel.attributedText!)
        
        updateTextFeildBorder()
        
        self.profileImageView.image = self.profile.image
        
        //-- Add date picker
        self.addYearPicker()
        
        self.saveButton.isHidden = true
        self.saveButtonImage.isHidden = true
        let bike = AppUser.currentUser().vehicle
        if self.profile.isCompleted || bike != nil{
            populateVehicle()
        }
        if self.isEditMode{
            self.skipButton.isHidden = true
        }
        
        changePlaceholderColor()
        addCharacterSpacingToTextFields()
        
    }
    
    //MARK: Private
    private func populateVehicle(){
        self.typeTextField.text = profile.vehicleType
        self.makeTextField.text = profile.vehicleMake
        self.modelTextField.text = profile.vehicleModel
        self.yearTextField.text = profile.vehicleYear
        self.skipButton.isHidden = true
    }
    /**
     * @method updateVehicle
     * @discussion update user vehicle deyails.
     */
    private func updateVehicle(){
        AppLoader.showLoader()
        let type = self.typeTextField.text!.trim()
        let make = self.makeTextField.text!.trim()
        let model = self.modelTextField.text!.trim()
        APIDataSource.updateProfile(service: .updateVehicle(vehicleType: type, vehicleMake: make, vehicleModel: model, vehicleManufacturingYear: self.yearTextField.text!), handler: { (user, error) in
            AppLoader.hideLoader()
            if isGuardObject(user) {
                AppUser.currentUser().updateUser(user: user!)
                AppToast.showSuccessMessage(message: vehicleUpdated)
                self.popViewController()
            }
            else{
                AppToast.showErrorMessage(message: error!)
            }
        })
    }
    
    /**
     * @method changePlaceholderColor
     * @discussion Change textfield placeholder.
     */
    private func changePlaceholderColor(){
        self.typeTextField.changePlaceholderColor(color: UIColor.placeholderColor())
        self.modelTextField.changePlaceholderColor(color: UIColor.placeholderColor())
        self.makeTextField.changePlaceholderColor(color: UIColor.placeholderColor())
        self.yearTextField.changePlaceholderColor(color: UIColor.placeholderColor())
    }
    
    private func updateTextFeildBorder(){
        //-- Update TextField Border Frame
        let borderFrame = CGRect(x: (self.typeTextField.frame.size.width - 126)/2, y: 49, width:  126, height: 1.0)
        self.typeTextField.updateBorderFrame(frame: borderFrame)
        self.makeTextField.updateBorderFrame(frame: borderFrame)
        self.modelTextField.updateBorderFrame(frame: borderFrame)
        self.yearTextField.updateBorderFrame(frame: borderFrame)
    }
    
    private func addCharacterSpacingToTextFields(){
        //-- Add spacing netween characters
        self.typeTextField.setCharacterSpace(space: 3.6)
        self.makeTextField.setCharacterSpace(space: 3.6)
        self.modelTextField.setCharacterSpace(space: 3.6)
        self.yearTextField.setCharacterSpace(space: 3.6)
    }
    
    /**
     * @method uploadImageToS3ServerAndRegisterUser
     * @discussion uploadImageToS3Server.
     */
    private func updateProfile(){
        AppLoader.showLoader()
        Utils.uploadProfileImageOnSS3(image: self.profile.image!) { (name, errorMessage) in
            if let imageName = name{
                APIDataSource.updateProfile(service: .updateProfile(fullName: self.profile.fullName, profileImage: imageName, vehicleType: self.typeTextField.text!.trim(), vehicleMake: self.makeTextField.text!.trim(), vehicleModel: self.modelTextField.text!.trim(), vehicleManufacturingYear: self.yearTextField.text!), handler: { (user, error) in
                    AppLoader.hideLoader()
                    if isGuardObject(user) {
                        AppUser.currentUser().updateUser(user: user!)
                        self.showSuccessPopup()
                    }
                    else{
                        AppToast.showErrorMessage(message: error!)
                    }
                })
            }
            else{
                AppLoader.hideLoader()
                AppToast.showErrorMessage(message: errorMessage!)
            }
        }
    }
    
    private func addYearPicker(){
        self.yearTextField.inputView = CustomPickerView(pickerComponent: [Utils.yearRange()], completion: { (picker, indexPath) in
            self.yearTextField.text = picker?.valueAt(indexPath: indexPath!)
            self.updateSpacingOfYearTextField()
        })
        (self.yearTextField.inputView as! CustomPickerView).selectRow(item: "\(Utils.currentYear())", inComponent: 0)
        self.yearTextField.addDoneOnKeyboardWithTarget(self, action: #selector(SignUpAddVehicalViewController.yearPickerDoneButtonTapped))
    }
    
    private func updateSpacingOfYearTextField(){
        self.yearTextField.setCharacterSpace(space: 3.6)
        self.yearTextField.setAttributedTextCharacterSpacing()
        self.textFieldEditingChanged(nil)
    }
    
    @objc func yearPickerDoneButtonTapped(){
        DLog(message: "Done button" as AnyObject)
        if self.yearTextField.isEmpty() {
            self.yearTextField.text = "\(Utils.currentYear())"
            self.updateSpacingOfYearTextField()
        }
        self.view.endEditing(true)
    }
    
    // MARK: - Validations
    private func isValidateTextFields(showAlert:Bool) -> Bool {
        if let message = self.validateTextFields() {
            if showAlert{
                AppToast.showErrorMessage(message: message)
            }
            return false
        }
        else{
            return true
        }
    }
    
    private func validateTextFields() -> String?{
        if let error = validateType(){
            return error
        }
        else if let error = validateMake(){
            return error
        }
        else if let error = validateModel(){
            return error
        }
        else if self.yearTextField.isEmpty(){
            return vehicleYearEmptyMessage
        }
        return nil
    }
    
    private func validateType() ->String?{
        if self.typeTextField.isEmpty(){
            return vehicleTypeEmptyMessage
        }
        else if !Validation.isAlphaNumeric(text: self.typeTextField.text!){
            return vehicleTypeAlphanumericMessage
        }
        return nil
    }
    
    private func validateMake() -> String? {
        if self.makeTextField.isEmpty(){
            return vehicleMakeEmptyMessage
        }
        else if !Validation.isAlphaNumeric(text: self.makeTextField.text!){
            return vehicleMakeAlphanumericMessage
        }
        return nil
    }
    
    private func validateModel() -> String?{
        if self.modelTextField.isEmpty(){
            return vehicleModelEmptyMessage
        }
        else if !Validation.isAlphaNumeric(text: self.modelTextField.text!){
            return vehicleModelAlphanumericMessage
        }
        return nil
    }
    
    func showSuccessPopup(){
        let bundle = Bundle(for: PopupViewController.self)
        let popupVC = PopupViewController(nibName: PopupViewController.nibName, bundle: bundle)
        popupVC.view.frame = UIScreen.main.bounds
        self.addChildViewController(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParentViewController: self)
        popupVC.showPopup(withImage: self.profile.image!, centerImageName:icSuccess,title:succesTitle, profileCompleteMessage, continueTitle, withDelegate: self)
    }
    
}

extension SignUpAddVehicalViewController{
    
    override func popupActionTapped() {
        self.pushToHome() //-- Push to dashboard view
    }
}
