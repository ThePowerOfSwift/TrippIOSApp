//
//  AlertBaseView.swift
//  Tripp
//
//  Created by Bharat Lal on 24/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class AlertBaseView: UIView {

    // custom view from the XIB file
    var view: UIView!
    var dismissbutton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
     Updates constraints for the view. Specifies the height and width for the view
     */
    override func updateConstraints() {
        super.updateConstraints()
        // View itself
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.height))
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: UIScreen.main.bounds.size.width))
        
        //Dismiss button
        addConstraint(NSLayoutConstraint(item: dismissbutton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dismissbutton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dismissbutton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: dismissbutton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        
    }
    /**
     Loads a view instance from the xib file
     
     - returns: loaded view
     */
    func loadViewFromXibFile(nibName: String) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let aView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return aView
    }
    
    //MARK: Helper
    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
    func setupView() {
        self.addTapGesture()
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        translatesAutoresizingMaskIntoConstraints = false
    }

     func hideView() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
     func addTapGesture(){
        
        dismissbutton = UIButton()
        dismissbutton.frame = bounds
        dismissbutton.addTarget(self, action: #selector(AlertBaseView.tapOnBackgroud), for: .touchUpInside)
        dismissbutton.backgroundColor = .clear
        dismissbutton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dismissbutton)
        self.sendSubview(toBack: dismissbutton)
    }
    @objc func tapOnBackgroud(){
        self.hideView()
    }
    /**
     Display animated view on a given view
     */
    func displayView(onView: UIView) {
        self.alpha = 0.0
        onView.addSubview(self)
        
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: onView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: onView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        onView.needsUpdateConstraints()
        
        // display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }, completion: nil
        )
    }

    
}
