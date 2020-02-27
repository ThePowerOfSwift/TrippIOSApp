//
//  AddTripTopBar.swift
//  Tripp
//
//  Created by Monu on 20/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AddTripTopBar: TopbarBaseView {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: SearchTextField!
    @IBOutlet weak var nameLabel: CharacterSpaceLabel!
    @IBOutlet weak var dateLabel: CharacterSpaceLabel!
    @IBOutlet weak var tripTypeLabel: CharacterSpaceLabel!
    @IBOutlet weak var tripIcon: UIImageView!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripDateTextField: UITextField!
    
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    var utcDateString = ""
    
    //MARK: Initialize filter view
    class func initializeBar() -> AddTripTopBar{
        let topBar = AddTripTopBar.fromNib()
        topBar.frame.size.width = Global.screenRect.size.width
        topBar.addBottomRoundedCorner()
        topBar.defaultViewSetup()
        return topBar
    }
    
    //MARK: Helper
    class func fromNib<T : AddTripTopBar>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    func defaultViewSetup(){
        let y = Devices.deviceName() == Model.iPhoneX.rawValue ? (UIApplication.shared.statusBarFrame.height - 20.0) : 0
        self.frame.origin.y = y
        
        self.expandOrCollapse()
        self.addBottomRoundedCorner()
    }
    
    func fillTripDetails(name: String, date: String, tripType: TripType){
        nameLabel.text = name
        dateLabel.text = date
        tripNameTextField.text = name
        tripDateTextField.text = date
        var imageName = ""
        var tripTypeName = ""
        switch tripType {
        case .Road:
            imageName = icTripRoad
            tripTypeName = "ROAD"
        case .Aerial:
            imageName = icTripAerial
             tripTypeName = "AERIAL"
        case .Sea:
            imageName = icTripSea
             tripTypeName = "SEA"
        default:
            imageName = icLocationWish
            tripTypeName = "POINTS"
        }
        tripIcon.image = UIImage(named: imageName)
        tripTypeLabel.text = tripTypeName
        configureDatePicker()
    }
    
    private func configureDatePicker(){
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(AddTripTopBar.changeDateFromDatePicker(_:)), for: .valueChanged)
        self.tripDateTextField.inputView = datePicker
    }
    
    @objc func changeDateFromDatePicker(_ sender: UIDatePicker) {
        formatter.dateFormat = AppDateFormat.UTCFormat
        utcDateString = formatter.string(from: datePicker.date)
        tripDateTextField.text = utcDateString.convertFormatOfDate(AppDateFormat.sortDate)
    }
    
    //MARK: IBAction methods
    @IBAction func searchButtonTapped(_ sender: Any?) {
        self.expandOrCollapse()
        let _ = self.isExpand == true ? self.searchField.becomeFirstResponder() : self.endEditing(true)
        if self.isExpand{
            UIView.animate(withDuration: 0.3, animations: { 
                self.searchButton.isHidden = true
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.searchButton.isHidden = false
            })
        }
    }
    
    
}
