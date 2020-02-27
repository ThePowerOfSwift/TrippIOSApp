//
//  BorderedTextField.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

@IBDesignable class BorderedTextField: UITextField {
    private var rightButton: UIButton?
    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 1.0
    @IBInspectable var placeHolerColor: UIColor = UIColor.black {
        didSet {
            setPlaceHolderColor()
        }
    }
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true

        //half of the width
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        //self.contentMode = UIViewContentMode.ScaleToFill
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.layer.shadowColor = UIColor.white.cgColor
        self.clipsToBounds = true

    }
    func addRightImageWithImage(_ image: UIImage) {
        rightButton = UIButton()
        rightButton?.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        rightButton?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        rightButton?.setImage(image, for: .normal)
        rightButton?.contentHorizontalAlignment = .left
        rightButton?.isUserInteractionEnabled = true
        rightView?.isUserInteractionEnabled = true
        rightButton?.addTarget(self, action: #selector(BorderedTextField.rightButtonAction), for: .touchUpInside)
        rightView = rightButton
        rightViewMode = .whileEditing
    }
    private func setPlaceHolderColor() {
        guard let _ = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedStringKey.foregroundColor: placeHolerColor])
    }
    @objc func rightButtonAction() {
        AppNotificationCenter.post(notification: AppNotification.textFieldRightViewTapped, withObject: ["textField": self])
    }
}

