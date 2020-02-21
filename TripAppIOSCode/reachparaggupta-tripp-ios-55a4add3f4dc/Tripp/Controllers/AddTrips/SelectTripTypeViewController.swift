//
//  SelectTripTypeViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 20/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SelectTripTypeViewController: AddTripBaseViewController {
    //MARK: IBOutlet/variables
    @IBOutlet weak var nextButton: RoundedBorderButton!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var happyLabel: CharacterSpaceLabel!
    @IBOutlet weak var clickToNextLabel: CharacterSpaceLabel!
    @IBOutlet weak var selectTypeLabel: CharacterSpaceLabel!
    @IBOutlet weak var roadIcon: UIImageView!
    @IBOutlet weak var aerialIcon: UIImageView!
    @IBOutlet weak var seaIcon: UIImageView!
    
    var selectedType = TripType.None
    //MARK:  Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private
    private func setupUI(){
        nextButton.addCharacterSpace(space: -0.3)
        nextButton.changeBorderColor(color: UIColor.appBlueColor(withAlpha: 0.64), borderRadius: 22)
        happyLabel.isHidden = true
        clickToNextLabel.isHidden = true
        selectTypeLabel.isHidden = false
        
    }
    private func unselectAll(){
        roadIcon.image = UIImage(named: icUnSelectedFilter)
        aerialIcon.image = UIImage(named: icUnSelectedFilter)
        seaIcon.image = UIImage(named: icUnSelectedFilter)
    }
    private func selectTypeWithTag(_ tag: Int){
        switch tag {
        case 1001:
            selectedType = .Road
            roadIcon.image = UIImage(named: icSelectedFilter)
        case 1002:
            selectedType = .Aerial
            aerialIcon.image = UIImage(named: icSelectedFilter)
        case 1003:
            selectedType = .Sea
            seaIcon.image = UIImage(named: icSelectedFilter)
        default:
            break
        }
        enableSavebutton()
        
    }
    private func enableSavebutton(){
        nextButton.isEnabled = true
        happyLabel.isHidden = false
        clickToNextLabel.isHidden = false
        selectTypeLabel.isHidden = true
        nextButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22)
        nextButton.titleLabel?.textColor = UIColor.blueButtonColor()
    }
    //MARK: IBActions
    @IBAction func nextTapped(_ sender: Any) {
        self.delegate?.trip.drivingMode = selectedType.rawValue
        if selectedType == TripType.Road{
             self.delegate?.showNextPage()
        }else{
           pushToAddWaypoint(walkThrough: delegate)
        }
       
    }
    @IBAction func tripTypeTapped(_ sender: UIButton) {
        self.unselectAll()
        self.selectTypeWithTag(sender.tag)
    }
}
