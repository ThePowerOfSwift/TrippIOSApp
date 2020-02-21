//
//  CategoryPickerView.swift
//  Tripp
//
//  Created by Bharat Lal on 09/12/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
protocol CategoryPickerDelegate: class {
    func skip()
    func addToMyTrip()
}
class CategoryPickerView: UIView {
    var picker = CustomPickerView()
    weak var delegate: CategoryPickerDelegate?
    convenience init(pickerComponent:[[String]], frame: CGRect) {
        self.init()
        self.frame = frame
        picker = CustomPickerView(pickerComponent: pickerComponent)
        picker.backgroundColor = UIColor.lightGray
        addToolBar()
        picker.frame = CGRect(x: 0, y: 40, width: frame.size.width, height: 216)
        self.addSubview(picker)
        
    }
    func addToolBar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CategoryPickerView.addToMyTrip))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        
        let cancelButton = UIBarButtonItem(title: "Skip", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CategoryPickerView.skip))
        
        toolbar.setItems([cancelButton,flexibleSpace ,doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        self.addSubview(toolbar)
        
    }
    
    @objc func addToMyTrip() {
        self.removeFromSuperview()
        if let delegate = self.delegate {
            delegate.addToMyTrip()
        }
    }
    @objc func skip() {
        self.removeFromSuperview()
        if let delegate = self.delegate {
            delegate.skip()
        }
    }
}
