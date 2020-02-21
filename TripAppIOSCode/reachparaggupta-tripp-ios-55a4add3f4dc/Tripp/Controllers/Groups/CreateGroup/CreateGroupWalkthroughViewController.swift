//
//  CreateGroupWalkthroughViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 01/06/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
import BWWalkthrough

class CreateGroupWalkthroughViewController: BWWalkthroughViewController {
    //MARK: - IBActions / variables
    @IBOutlet weak var discardButton: UIButton!
    
    var group =  Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupWalkthrough()

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
        let first = groupsStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.createGroupName.rawValue) as! CreateGroupNameViewController
        let second = groupsStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.createGroupImage.rawValue) as! CreateGroupImageViewController
        
        let third = groupsStroryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.createGroupInvite.rawValue) as! CreateGroupInvitePeopleViewController
        
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
    func enableCloseButton(){
        self.discardButton.isEnabled = true
    }
    @IBAction func closeTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.discardButton.isEnabled = false
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
