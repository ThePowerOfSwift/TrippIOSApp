//
//  RouteFilterView.swift
//  Tripp
//
//  Created by Monu on 10/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class RouteFilterView: UIView {

    @IBOutlet weak var filterButton: RoundedBorderButton!
    @IBOutlet weak var clearSelectionButton: UIButton!
    @IBOutlet weak var saperatorView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    @IBOutlet weak var filterLabel: UILabel!
    var filters: [RouteFilter] = []
    var isFilterHidden: Bool = true
    var handler: FilterCloseHandler?
    
    //MARK: Initialize filter view
    class func initializeFilter() -> RouteFilterView{
        let filterView = RouteFilterView.fromNib()
        var rect = UIScreen.main.bounds
        let yPoint = rect.size.height - 148
        let height = Devices.deviceName() == Model.iPhoneX.rawValue ? 148.0 + 35.0 : 148.0
        let y = Devices.deviceName() == Model.iPhoneX.rawValue ? yPoint - 35 : yPoint

        rect.origin.y = y
        rect.size.height = CGFloat(height)
        filterView.frame = rect
        filterView.saperatorView.isHidden = true
        filterView.filterCollectionView.register(UINib(nibName: NibIdentifier.filterView.rawValue, bundle: nil), forCellWithReuseIdentifier: FilterViewCell.identifier)
        return filterView
    }
    
    //MARK: Life Cycle
    override func awakeFromNib(){   
        self.setupView()
    }
    
    //MARK: Private Methods
    private func setupView(){
        self.clearSelectionButton.characterSpace(space: -0.6)
        self.filterButton.addCharacterSpace(space: -0.6)
        self.filterButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 21)
        self.fillFilters()
        self.addTopRoundedCorner()
        self.addShadow()
    }
    
    private func addShadow(){
        self.addShadowWithColor(color: UIColor.shadow(), opacity: 5.0, offset: CGSize(width: 2, height: -5), radius: 5.0)
    }
    
    private func addTopRoundedCorner(){
        self.layer.cornerRadius = 10.0
    }
    
    private func fillFilters(){
        self.filters.append(RouteFilter(color: UIColor.filterOrange(), isSelected: false, title: gasStationFilter, logo: icGasStation, value:filterGasStation))
        self.filters.append(RouteFilter(color: UIColor.filterPink(), isSelected: false, title: hotelsFilter, logo: icHotels, value:filterHotels))
        self.filters.append(RouteFilter(color: UIColor.filterLime(), isSelected: false, title: campGroundFilter, logo: icCampGround, value:filterCampGround))
        self.filters.append(RouteFilter(color: UIColor.filterGreen(), isSelected: false, title: stateParkFilter, logo: icStatePark, value:filterPark))
        self.filters.append(RouteFilter(color: UIColor.filterBlue(), isSelected: false, title: landMarkFilter, logo: icLandMark, value:filterLandMark))
    }
    
    func selectedFilters(){
        _ = self.filters.filter() { $0.isSelected == true }
    }
    
    func isEnableClearSelectionButton(enable : Bool){
        self.clearSelectionButton.isEnabled = enable
        self.clearSelectionButton.setTitleColor(enable ? UIColor.blueButtonColor() : UIColor.appBlueColor(), for: .normal)
    }
    
    //MARK: Helper
    class func fromNib<T : RouteFilterView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    //MARK: IBAction Methods
    @IBAction func filterButtonTapped(_ sender: Any) {
        let iPhoneX = Devices.deviceName() == Model.iPhoneX.rawValue ? true : false
        let yPoint = UIScreen.main.bounds.size.height - 148
        let height = iPhoneX ? 148.0 + 35.0 : 148.0
        let y = iPhoneX ? yPoint - 35 : yPoint
        
        UIView.animate(withDuration: 0.3) { 
            if self.isFilterHidden {
                let h = UIScreen.main.bounds.size.height - 80
                self.frame.size.height = iPhoneX ? h - 60 : h
                self.frame.origin.y = iPhoneX ? 110 : 80
                self.saperatorView.isHidden = false
                self.filterButton.alpha = 0.0
                self.doneButton.alpha = 1.0
                self.filterLabel.alpha = 1.0
                self.isFilterHidden = false
            }
            else{
                self.frame.size.height = CGFloat(height)
                self.frame.origin.y = y
                self.saperatorView.isHidden = true
                self.filterButton.alpha = 1.0
                self.doneButton.alpha = 0.0
                self.filterLabel.alpha = 0.0
                self.isFilterHidden = true
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.filterButtonTapped(sender)
        if let completion = self.handler {
            let filtered = self.filters.filter() { $0.isSelected == true }
            let filterString = filtered.map({"\($0.value)"}).joined(separator: "|")
            completion(.done, filterString)
        }
    }
    
    @IBAction func clearSelectionButtonTapped(_ sender: Any) {
        for item in self.filters{
            item.isSelected = false
        }
        self.filterCollectionView.reloadData()
        if let completion = self.handler {
            completion(.clear, "")
        }
    }
    
}
