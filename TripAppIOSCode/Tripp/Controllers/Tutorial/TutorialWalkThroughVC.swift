//
//  TutorialWalkThroughVC.swift
//  Tripp
//
//  Created by Monu on 03/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import BWWalkthrough

class TutorialWalkThroughVC: BWWalkthroughViewController,BWWalkthroughViewControllerDelegate {

    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activeImage: UIImageView!
    
    @IBOutlet weak var pageControlView: CustomPageControlImage!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var closeTutorialButton: UIButton!
    
    
    //MARK: UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWalkthrough()
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
    
    //MAKR: Private methods
    private func setupWalkthrough(){
        self.scrollview.bounces = false
        self.scrollview.isScrollEnabled = false
        delegate = self
        
               
        //-- Initiate all onboarding screens
        let first = tutorialStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.tutorialRoutes.rawValue) as! TutorialRoutesViewController
        let second = tutorialStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.tutorialFilter.rawValue) as! TutorialRoutesFilterVC
        let third = tutorialStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.tutorialAddTripp.rawValue) as! TutorialAddTrippViewControllerVC
        let fourth = tutorialStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.tutorialSavePoint.rawValue) as! TutorialSavePointVC
        let fifth = tutorialStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.tutorialSaveOtherPoint.rawValue) as! TutorialSaveOtherPointVC
        let sixth = tutorialStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.tutorialSearch.rawValue) as! TutorialSearchVC
        let seventh = tutorialStoryBoard().instantiateViewController(withIdentifier: StoryboardViewControllerIdentifier.tutorialFinished.rawValue) as! TutorialEndFinishVC
        
        //-- Set delegates
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        fifth.delegate = self
        sixth.delegate = self
        seventh.delegate = self
        
        //-- Add onboarding view as child
        self.add(viewController: first)
        self.add(viewController: second)
        self.add(viewController: third)
        self.add(viewController: fourth)
        self.add(viewController: fifth)
        self.add(viewController: sixth)
        self.add(viewController: seventh)
    }

    private func setupTutorialTitle(){
        if currentPage == 0{
            self.headerImageView.image = UIImage(named: icTutorialRoutes)
        }
        else {
            self.headerImageView.image = UIImage(named: icTutorialAddTrip)
        }
    }
    
    func walkthroughPageDidChange(_ pageNumber:Int) {
        stackView.insertArrangedSubview(activeImage, at: pageNumber)

    }
    

    //-- Show next screen
    func tapGotItButton(){
        
        self.headerImageView.isHidden = currentPage == 4 ? true : false
        self.closeTutorialButton.alpha = currentPage >= 5 ? 0.78 : 1.0
        
        setupTutorialTitle()
        
        if currentPage == 6 {
            PopupViewController.showTutorialFinishAlert(controller: self, withDelegate: self)
        }
        else{
            self.nextPage()
        }
    }
    
    //MARK: IBAction methods
    @IBAction func closeButtonTapped(_ sender: Any) {
        if currentPage != 6 {
            self.popViewController()
        }
    }
    
    
    
}

extension TutorialWalkThroughVC: PopupActionDelegate{
    
    func popupActionTapped() {
        self.popViewController()
    }
}
