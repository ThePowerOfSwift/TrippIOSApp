//
//  RoutesTopView.swift
//  Tripp
//
//  Created by Bharat Lal on 20/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import  TTTAttributedLabel

enum RouteViewType: Int{
    case map = 1
    case list
}
enum Tab{
    case Routes
    case MyTrips
}
protocol RouteViewTypeDelegate {
    
    func routeViewChanged(to viewType: RouteViewType)
    func clearFilter()
}
class RoutesTopView: UIView {
    //MARK: --------- variables/IBOutlet
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var routesCountLabel: TTTAttributedLabel!
    @IBOutlet weak var searchTextFleid: SearchTextField!
    @IBOutlet weak var searchIcon: UIButton!
    @IBOutlet weak var listIcon: UIButton!
    @IBOutlet weak var mapIcon: UIButton!
    @IBOutlet weak var saveTripslabel: CharacterSpaceLabel!
    
    var delegate: RouteViewTypeDelegate?
    
    var isSearchViewOpen = false
    var height: NSLayoutConstraint?
    let animationDureation = 0.5
    var selectedTab: Tab = .Routes
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        self.infoLabel.addCharactersSpacing(spacing: 2.2, text: self.infoLabel.text!)
        self.routesCountLabel.addCharactersSpacing(spacing: -0.3, text: self.routesCountLabel.text as! String)
    }
    //MARK: IBActions
    @IBAction func toggleSearch(_ sender: UIButton?) {
        
        if self.isSearchViewOpen{
            self.closeSearchBar()
        }else{
            self.openSearchBar()
        }
        self.isSearchViewOpen = !self.isSearchViewOpen
        self.animateButtonImage()
    }
    
    @IBAction func listViewTapped(_ sender: UIButton) {
        if sender.isSelected{
            return
        }
        sender.isSelected = true
        mapIcon.isSelected = false
        if let _ = delegate{
            self.mapIcon.setImage(UIImage(named: icMapIcon), for: .normal)
            self.listIcon.setImage(UIImage(named: listIconSelected), for: .normal)
            delegate!.routeViewChanged(to: .list)
        }
    }
    
    @IBAction func mapViewTapped(_ sender: UIButton) {
        if sender.isSelected{
            return
        }
        sender.isSelected = true
        listIcon.isSelected = false
        if let _ = delegate{
            self.mapIcon.setImage(UIImage(named: icMapSelected), for: .normal)
            self.listIcon.setImage(UIImage(named: icListIcon), for: .normal)
            delegate!.routeViewChanged(to: .map)
        }
    }
    //MARK: Helper
    class func fromNib<T : RoutesTopView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    func openSearchBar(){
        self.animateViewHeight(163)
    }
    func closeSearchBar(){
        self.animateViewHeight(90)
    }
    func animateViewHeight(_ height: CGFloat){
        self.height?.constant = height
        self.setNeedsUpdateConstraints()
        self.searchTextFleid.alpha = 0.0
        UIView.animate(withDuration: animationDureation, animations: {
            self.searchTextFleid.alpha = 1.0
            self.superview?.layoutIfNeeded()
            
        })
    }
    func animateButtonImage(){
        var imageName = ""
        var transition: UIViewAnimationOptions = .transitionFlipFromRight
        if self.isSearchViewOpen{
            imageName = icCloseButton
            transition = .transitionFlipFromRight
            self.searchTextFleid.becomeFirstResponder()
            
        }else{
            imageName = icSearchButton
            transition = .transitionFlipFromLeft
            self.searchTextFleid.resignFirstResponder()
        }
        UIView.transition(with: self.searchIcon, duration: animationDureation, options: transition, animations: {
            self.searchIcon.setImage(UIImage(named: imageName), for: .normal)
        }, completion: nil)
    }
    func addOnView(view: UIView){
        view.addSubview(self)
        self.clipsToBounds = true
        addConstraintWith(view: view)
        view.bringSubview(toFront: self)
        
    }
    func updateTopViewAccordingToTab(){
        if self.selectedTab == .Routes{
            self.saveTripslabel.isHidden = true
            self.infoLabel.isHidden = false
            self.routesCountLabel.isHidden = false
        }else{
            self.infoLabel.isHidden = true
            self.routesCountLabel.isHidden = true
            self.saveTripslabel.isHidden = false
        }
    }
    func makeBottomCornerRounded(){
        //roundCornersWithLayerMask(12, corners: [.bottomLeft,.bottomRight])
        roundCorner([.bottomLeft, .bottomRight], radius: 12)
    }
    
    func addConstraintWith(view:UIView){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let left = self.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let top = self.topSafeAreaConstaintsOnView(view)
        let right = self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        height = self.heightAnchor.constraint(equalToConstant: 90.0)
        
        NSLayoutConstraint.activate([
            top, left,
            right,
            height!])
    }
    func updateRouteCounterInfo(_ count: Int, isFilter: Bool = false, isFetching: Bool = false){
        var text = isFilter ? "\(count)" + routeCountWithFilterMessage : "\(count)" + routeCountMessage
        if isFetching{
            text = fetchingRoutes
            self.addRoutesCountLabel(text: text, filter: false)
        }else{
        
        self.addRoutesCountLabel(text: text, filter: isFilter)
        }
    }
    private func addRoutesCountLabel(text: String, filter: Bool){
        
        let attributedString = String.createAttributedString(text: text, font: UIFont.openSensSemiBold(size: 17), color: UIColor.blueButtonColor(), spacing: -0.3)
        
        routesCountLabel.delegate = self
        routesCountLabel.numberOfLines = 0
        routesCountLabel.textAlignment = NSTextAlignment.left
        routesCountLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        routesCountLabel.textInsets = .zero
        routesCountLabel.setText(attributedString)
        if filter{
            let linkAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.clearFilterLinkColor(),
                NSAttributedStringKey.font: UIFont.openSensSemiBold(size: 12),
                NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue
                ] as [NSAttributedStringKey : Any]
            
            routesCountLabel.linkAttributes = linkAttributes
            routesCountLabel.activeLinkAttributes = linkAttributes
            
            let signInLinkRange = (text as NSString).range(of:clearFilters)
            let signInURL = NSURL(string:LinkTapEvent.clearFilterEvent)
            routesCountLabel.addLink(to: signInURL as URL!, with:signInLinkRange)
            routesCountLabel.isUserInteractionEnabled = true
        }
    }
    
}
//MARK: ------------------- Delegates  --------------------

//MARK: TTTAttributedLabelDelegate
extension RoutesTopView: TTTAttributedLabelDelegate{
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        if let url = url, url.absoluteString == LinkTapEvent.clearFilterEvent {
            DLog(message: "clear tapped" as AnyObject)
            delegate!.clearFilter()
        }
        
    }
}

