//
//  CustomPickerView.swift
//  Tripp
//
//  Created by Monu on 31/05/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
typealias PickerHandler = (_ picker:CustomPickerView?, _ indexPath: NSIndexPath?) -> ()
class CustomPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var handler: PickerHandler?
    
    var pickerComponent:[[String]] = []
    
    var selectedRow:[String] = []
    
    //MARK: Initialize
    convenience init(pickerComponent:[[String]], completion:@escaping PickerHandler) {
        self.init()
        self.handler = completion
        self.commonInit(pickerComponent)
    }
    convenience init(pickerComponent:[[String]]) {
        self.init()
        self.commonInit(pickerComponent)
    }
    func commonInit(_ pickerComponent:[[String]]) {
        self.delegate = self
        self.dataSource = self
        self.pickerComponent = pickerComponent
        self.frame.size.height = 216.0
        
        //-- Setup selected row
        for component in pickerComponent {
            if component.count > 0 {
                selectedRow.append(component.first!)
            }
            else{
                selectedRow.append("")
            }
        }
    }
    
    //-- UIPickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return pickerComponent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerComponent[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return pickerComponent[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerComponent.count > component, pickerComponent[component].count > row {
            self.selectedRow[component] = pickerComponent[component][row]
            
            if let block = handler {
                block(self, NSIndexPath(item: row, section: component))
            }
        }
    }
    
    //MARK: Access value
    func valueAt(indexPath:NSIndexPath) -> String{
        return pickerComponent[indexPath.section][indexPath.row]
    }
    
    func selectRow(item: String, inComponent: Int){
        if let row = pickerComponent[inComponent].index(of: item){
            self.selectRow(row, inComponent: inComponent, animated: false)
        }
    }

}
