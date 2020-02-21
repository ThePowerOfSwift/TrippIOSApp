//
//  SelectTripModeViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 18/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SelectTripModeViewController: AddTripBaseViewController {
    //MARK: IBOutlet/variables
    @IBOutlet weak var nextButton: RoundedBorderButton!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var manualIcon: UIImageView!
    @IBOutlet weak var liveIcon: UIImageView!
    
    var selectedType = TripType.None
    var selectedTripMode = TripMode.Manual
    //MARK:  Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    private func unselectAll(){
        manualIcon.image = UIImage(named: icUnSelectedFilter)
        liveIcon.image = UIImage(named: icUnSelectedFilter)
    }
    private func selectTypeWithTag(_ tag: Int){
        switch tag {
        case 1001:
            selectedTripMode = .Manual
            manualIcon.image = UIImage(named: icSelectedFilter)
        case 1002:
            selectedTripMode = .Live
            liveIcon.image = UIImage(named: icSelectedFilter)
        default:
            break
        }
        enableSavebutton()
        
    }
    private func enableSavebutton(){
        nextButton.isEnabled = true
        nextButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22)
        nextButton.titleLabel?.textColor = UIColor.blueButtonColor()
    }
    //MARK: IBActions
    @IBAction func nextTapped(_ sender: Any) {
        self.delegate?.trip.tripMode = selectedTripMode.rawValue
        if selectedTripMode == .Manual{
            pushToAddWaypoint(walkThrough: delegate)
        }else{
            pushToAddLiveTrip(walkThrough: delegate)
        }
    }
    @IBAction func tripModeTapped(_ sender: UIButton) {
        self.unselectAll()
        self.selectTypeWithTag(sender.tag)
    }
}
