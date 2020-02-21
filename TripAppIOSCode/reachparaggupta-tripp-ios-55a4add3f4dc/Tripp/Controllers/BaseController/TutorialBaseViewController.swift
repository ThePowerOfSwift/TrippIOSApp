//
//  TutorialBaseViewController.swift
//  Tripp
//
//  Created by Monu on 04/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class TutorialBaseViewController: UIViewController {

    weak var delegate: TutorialWalkThroughVC?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var arrowImage: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var subTitleLabel: UILabel?
    
    
    //MARK: UIViewController Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: IBAction Methods
    @IBAction func gotItButtonTapped(_ sender: Any) {
        delegate?.tapGotItButton()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        delegate?.tapGotItButton()
    }
    
    //MARK: Public methods
    func setTitleAttributedText(text: String, boldTexts:[String]){
        self.titleLabel?.attributedText = self.createAttributedText(text: text, boldTexts: boldTexts)
    }
    
    func setSubTitleAttribute(text: String, boldTexts:[String]){
        self.subTitleLabel?.attributedText = self.createAttributedText(text: text, boldTexts: boldTexts)
    }
    
    //MARK: Private Methods
    private func setupView(){
        contentView.addShadowWithColor(color: UIColor.shadow(), opacity: 0.92, offset: CGSize(width: 0, height: 2), radius: 3)
        arrowImage?.addShadowWithColor(color: UIColor.shadow(), opacity: 0.43, offset: CGSize(width: 0, height: 2), radius: 3)
    }
    
    private func createAttributedText(text: String, boldTexts:[String]) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string:text, attributes: [
            NSAttributedStringKey.font: UIFont.openSensRegular(size: 16),
            NSAttributedStringKey.foregroundColor: UIColor.tutorialTextColor(),
            ])
        
        for message in boldTexts {
            let range = (text as NSString).range(of:message)
            let attribute = [NSAttributedStringKey.font: UIFont.openSensBold(size: 16)]
            attributedString.addAttributes(attribute, range: range)
        }
        
        return attributedString
    }
    
}
