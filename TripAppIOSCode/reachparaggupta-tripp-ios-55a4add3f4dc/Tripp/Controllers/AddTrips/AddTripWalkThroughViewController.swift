//
//  AddTripWalkThroughViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 20/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import BWWalkthrough


class AddTripWalkThroughViewController: BWWalkthroughViewController {
    @IBOutlet weak var discardButton: UIButton!
    
    var trip = Route()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupWalkthrough()
        trip.isMyTrip = true // yes it is my trip
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    //MAKR: Private methods
    private func setupWalkthrough(){
        self.scrollview.bounces = false
        self.scrollview.isScrollEnabled = false
        
        //-- Initiate all onboarding screens
        let first = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.addTripName.rawValue) as! AddTripNameViewController
        let second = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.selectTriptype.rawValue) as! SelectTripTypeViewController
        
        let third = addTripsStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.selectTripMode.rawValue) as! SelectTripModeViewController
        
        first.delegate = self
        second.delegate = self
        third.delegate = self
        
        
        //-- Add onboarding view as child
        self.add(viewController: first)
        self.add(viewController: second)
        self.add(viewController: third)
    }
    
    func showNextPage(){
        self.nextPage()
    }
    @objc func enableCloseButton(){
        self.discardButton.isEnabled = true
    }
    @IBAction func closeTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.discardButton.isEnabled = false
        self.perform(#selector(AddTripWalkThroughViewController.enableCloseButton), with: nil, afterDelay: 0.5)
        let alert = AddRoutesAlertPopupView(cancelTripWarning, actionButtonTitle: removeTitle) { buttonIndex in
            if buttonIndex == 2{
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        alert.displayView(onView: windowGlobal != nil ? windowGlobal! : self.view)
    }
}
