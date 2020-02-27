//
//  CharacterSpaceLabel.swift
//  Tripp
//
//  Created by Monu on 23/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable class CharacterSpaceLabel: UILabel {

    
    // MARK: Inspectable properties
    @IBInspectable var spacing: CGFloat = 0.0 {
        didSet{
            setupView()
        }
    }
    
    
    // MARK: Internal functions
    
    // Setup the view appearance
    private func setupView(){
        self.addCharactersSpacing(spacing: spacing, text: (self.text == nil) ? "" : self.text!)
        self.setNeedsDisplay()
        
    }
    //MARK: -- override
    override var text: String?{
        didSet{
            setupView()
        }
    }

}
