//
//  UserTypeSelectionController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 10/11/21.
//

import UIKit

protocol UserTypeSelectionDelegate: AnyObject {
    func typeSelected(_ userType: UserType)
}

class UserTypeSelectionController: NSObject {
    weak var delegate: UserTypeSelectionDelegate?
    let labels = UserType.allCases
    lazy var userTypePickerView = UserTypeSelectionView(pickerDataSource: self, pickerDelegate: self)
}

extension UserTypeSelectionController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        labels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        labels[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userTypeSelected = labels[row]
        delegate?.typeSelected(userTypeSelected)
    }
}
