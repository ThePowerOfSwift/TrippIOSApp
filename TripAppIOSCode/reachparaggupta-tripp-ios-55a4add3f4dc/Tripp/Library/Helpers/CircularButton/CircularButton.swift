import UIKit

@IBDesignable class CircularButton: UIButton {

    @IBInspectable var borderColor: UIColor = UIColor.white
    @IBInspectable var borderWidth: CGFloat = 0.0

    override func draw(_ rect: CGRect) {

        //half of the width
        self.layer.cornerRadius = rect.size.width / 2.0
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.shadowColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true

        
        
    }
}
