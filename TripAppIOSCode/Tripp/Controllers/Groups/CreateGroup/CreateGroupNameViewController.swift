//
//  CreateGroupNameViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 01/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class CreateGroupNameViewController: UIViewController {
   
    //MARK: IBOutlet/variables
    @IBOutlet weak var nextButton: RoundedBorderButton!
    @IBOutlet weak var nameTextField: BottomBorderTextField!
    
     weak var delegate: CreateGroupWalkthroughViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - private
    private func setupUI(){
        nextButton.addCharacterSpace(space: -0.3)
        nextButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22)
        nameTextField.setCharacterSpace(space: 0.3)
        if let group = delegate?.group, group.groupId != 0 { // edit mode
            nameTextField.text = group.name
        }
    }
    private func validateTextField() -> Bool{
        if nameTextField.isEmpty(){
            AppToast.showErrorMessage(message:groupNameMessage)
            return false
        }
        return true
    }
    //MARK: IBActions
    @IBAction func nextTapped(_ sender: Any) {
        if validateTextField(){
            view.endEditing(true)
            delegate?.group.name = (nameTextField.text?.trim())!
            delegate?.showNextPage()
        }
    }

}
