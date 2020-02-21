//
//  AddTripNameViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 19/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AddTripNameViewController: AddTripBaseViewController {
    //MARK: IBOutlet/variables
    @IBOutlet weak var nextButton: RoundedBorderButton!
    @IBOutlet weak var categoryTextField: BottomBorderTextField!
    @IBOutlet weak var nameTextField: BottomBorderTextField!
    @IBOutlet weak var dateTextField: BottomBorderTextField!
    @IBOutlet weak var groupTextField: BottomBorderTextField!
    
    var utcDateString = ""
    var categories = [Category]()
    var groups = [Group]()
    var selectedGroup: Group?
    var categoryNames: [String] = []
    var selectedCategory: Category?
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.fetchCategories()
        self.fetchGroups()
        
    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private
    private func fetchCategories(){
         AppLoader.showLoader()
        CategoryManager.sharedManager.fetchCategories { (categories, error) in
             AppLoader.hideLoader()
            if let _ = categories{
                self.categories = categories!
                self.categoryNames = self.categories.map( { $0.name })
                self.configureCategoryPicker()
            }
        }
    }
    private func fetchGroups(){
        AppLoader.showLoader()
        APIDataSource.groupListing(service: .groupList(page: 1)) { [weak self] (groups, paging, message) in
            AppLoader.hideLoader()
            if let groupsResponse = groups{
                self?.groups = groupsResponse
                self?.configureGroupPicker()
            }
        }
    }
    private func setupUI(){
        nextButton.addCharacterSpace(space: -0.3)
        nextButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22)
        nameTextField.setCharacterSpace(space: 0.3)
        dateTextField.setCharacterSpace(space: 0.3)
        categoryTextField.setCharacterSpace(space: 0.3)
        groupTextField.setCharacterSpace(space: 0.3)
        groupTextField.delegate = self
        dateTextField.addDoneOnKeyboardWithTarget(self, action: #selector(AddTripNameViewController.datePickerDoneButtonTapped))
        categoryTextField.delegate = self
        configureDatePicker()
        configureCategoryPicker()
        nameTextField.becomeFirstResponder()
    }
    private func configureDatePicker(){
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(AddTripNameViewController.updateTextField(_:)), for: .valueChanged)
        self.dateTextField.inputView = datePicker
    }
    private func configureCategoryPicker(){
        categoryTextField.inputView = CustomPickerView(pickerComponent: [categoryNames], completion: { (picker, indexPath) in
            self.selectedCategory = self.categories[(indexPath?.item)!]
            self.categoryTextField.text = self.selectedCategory!.name
        })
    }
    
    private func configureGroupPicker() {
        let groupList: [String] = self.groups.flatMap({$0.name})
        if groupList.count > 0 {
            groupTextField.inputView = CustomPickerView(pickerComponent: [groupList], completion: { [weak self] (picker, indexPath) in
                self?.groupTextField.text = self?.groups[indexPath?.item ?? 0].name
                self?.selectedGroup = self?.groups[indexPath?.item ?? 0]
            })
        } else {
            groupTextField.inputView = CustomPickerView(pickerComponent: [[""]], completion: { (picker, indexPath) in
                
            })
        }
    }
    
    @objc func updateTextField(_ sender: UIDatePicker){
        setDateFromDatePicker()
    }
    private func validateTextField() -> Bool{
        if nameTextField.isEmpty(){
            AppToast.showErrorMessage(message:addTripNameMessage)
            return false
        }
        if dateTextField.isEmpty(){
            AppToast.showErrorMessage(message: addTripDateMessage)
            return false
        }
        return true
    }
    @objc func datePickerDoneButtonTapped(){
        if dateTextField.isEmpty(){
            setDateFromDatePicker()
        }
        self.view.endEditing(true)
    }
    private func setDateFromDatePicker() {
        formatter.dateFormat = AppDateFormat.UTCFormat
        utcDateString = formatter.string(from: datePicker.date)
        dateTextField.text = utcDateString.convertFormatOfDate(AppDateFormat.sortDate)
    }
    //MARK: IBActions
    @IBAction func nextTapped(_ sender: Any) {
        if validateTextField(){
            self.delegate?.trip.name = (nameTextField.text?.trim())!
            self.delegate?.trip.createdAt = utcDateString
            self.delegate?.trip.groupId = selectedGroup?.groupId ?? 0
            if let category = selectedCategory{
                 self.delegate?.trip.categoryId.value = category.categoryId
            }
            self.delegate?.showNextPage()
        }
    }
    
}

extension AddTripNameViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryTextField && textField.hasText == false && categories.count != 0 {
            categoryTextField.text = categories[0].name
            self.selectedCategory = self.categories[0]
        } else if textField == groupTextField && textField.hasText == false && groups.count != 0 {
            groupTextField.text = groups[0].name
            self.selectedGroup = self.groups[0]
        }
    }
}

