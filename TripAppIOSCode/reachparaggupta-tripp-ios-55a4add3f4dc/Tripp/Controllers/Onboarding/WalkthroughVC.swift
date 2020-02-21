//
//  WalkthroughVC.swift
//  Tripp
//
//  Created by Monu on 16/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import BWWalkthrough

class WalkthroughVC: BWWalkthroughViewController {

    @IBOutlet weak var signUpButton: RoundedBorderButton!
    @IBOutlet weak var signInButton: RoundedBorderButton!
    //@IBOutlet weak var signUpButton: UIButton!
    //@IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWalkthrough()
        
        if AppUserDefaults.value(for: .walkthrough) as? Bool != true {
            showWalkthrough()
        }
        
        //self.pushLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollview.bounces = false
    }
    
    //MARK: IBAction methods
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.pushSignUp()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        self.pushLogin()
    }
    
    //MAKR: Private methods
    private func setupWalkthrough(){
        //-- Initiate all onboarding screens
        let page_first = onboardingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.onboardingFirstVC.rawValue)
        let page_second = onboardingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.onboardingSecondVC.rawValue)
        let page_third = onboardingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.onboardingThirdVC.rawValue)
        let page_fourth = onboardingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.onboardingFourthVC.rawValue)
        let page_fifth = onboardingStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.onboardingFifthVC.rawValue)
        
        //-- Add onboarding view as child
        self.add(viewController: page_first)
        self.add(viewController: page_second)
        self.add(viewController: page_third)
        self.add(viewController: page_fourth)
        self.add(viewController: page_fifth)
        
        //-- Add character space on button
        self.signUpButton.addCharacterSpace(space: 0.0)
        self.signInButton.addCharacterSpace(space: 0.0)
        
        self.signUpButton.changeBorderColor(color: UIColor.buttonBorderColor(), borderRadius: 13.0)
        self.signInButton.changeBorderColor(color: UIColor.buttonBorderColor(), borderRadius: 13.0)
        
        if AppUser.isLoginUser() {
            self.backButton.isHidden = false
            self.signInButton.isHidden = true
            self.signUpButton.isHidden = true
        }
        else{
            self.backButton.isHidden = true
            self.signInButton.isHidden = false
            self.signUpButton.isHidden = false
        }
    }
    
    private func showWalkthrough() {
        
        
        let alertController = UIAlertController(title: nil, message: showVideoTitle, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: cancel, style: .cancel) { action -> Void in
            AppUserDefaults.set(value: true, for: .walkthrough)
        }

        
        let editAction = UIAlertAction(title: showVideo, style: .default) { action -> Void in
            
            guard let walkthrough = AppUserDefaults.value(for: .walkthrough) as? Bool, walkthrough == true else {
                VideoManager.playVideoWithUrl(viewController: self, url: walkthroughVideoURL)
                AppUserDefaults.set(value: true, for: .walkthrough)
                return
            }

            //Just dismiss the action sheet
        }
        alertController.addAction(editAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
    }

}
