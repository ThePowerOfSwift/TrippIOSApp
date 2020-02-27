//
//  MapFilterView.swift
//  Tripp
//
//  Created by Bharat Lal on 13/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
enum FilterAction {
    case close
    case done
    case clear
}
typealias FilterCloseHandler = (_ action: FilterAction, _ selectedFilters: String) -> ()
typealias TripsFilterCloseHandler = (_ action: FilterAction, _ categoryIds: String, _ isWish: Bool) -> ()
class MapFilterView: UIView {

    @IBOutlet weak var clearSelectionButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var saperatorView: UIView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var filters: [RouteFilter] = []
    var routeTypeFilters: [RouteFilter] = []
    var sectionNames = [String]()
    var selectedFilters = [RoadType]()
    var handler: FilterCloseHandler?
    
    //Trip filters
    var isTripsFilter = false
    var selectedDrivingModes = [TripType]()
    var isLiveTripOn: Bool? = nil
    var selectedCategoryIds = [String]()
    var categories: [Category]? = nil
    var tripFilterHandler: TripsFilterCloseHandler?
    var isWishFilterOn: Bool = true
    
    //MARK: Initialize filter view
    class func initializeFilter(selectedFilters: String) -> MapFilterView{
        let filterView = MapFilterView.fromNib()
        filterView.setup(false)
        
        if selectedFilters.isEmpty == false{
            let filterRawValues = selectedFilters.components(separatedBy: ",")
            
            filterView.selectedFilters =  filterRawValues.map({RoadType(rawValue: Int($0)!)!})
        }
        filterView.fillFilters()
        filterView.fillRouteTypeFilters()
        return filterView
    }
    class func initializeFilter(selectedModes: String, selectedCategoryIds: String, isLiveTripSelected: Bool?, avaibalbeCategories: [Category]?, isWish: Bool = true) -> MapFilterView{
        let filterView = MapFilterView.fromNib()
        filterView.setup(true)
        filterView.categories = avaibalbeCategories
        if selectedModes.isEmpty == false {
            let filterRawValues = selectedModes.components(separatedBy: ",")
            
            filterView.selectedDrivingModes =  filterRawValues.map({TripType(rawValue: Int($0)!)!})
        }
        filterView.isLiveTripOn = isLiveTripSelected
        filterView.isWishFilterOn = isWish
        if selectedCategoryIds.isEmpty == false {
            filterView.selectedCategoryIds = selectedCategoryIds.components(separatedBy: ",")
        }
        filterView.fillTripFilters()
        return filterView
    }
    func setup(_ isTripsFilter: Bool){
        var rect = UIScreen.main.bounds
        let h = UIScreen.main.bounds.size.height - 80
        let iPhoneX = Devices.deviceName() == Model.iPhoneX.rawValue ? true : false
        let height = iPhoneX ? h : h + 35.0
        let y = iPhoneX ? 80 - 35 : 80
        
        rect.size.height = height
        rect.origin.y = CGFloat(y)
        frame = rect
        
        filterCollectionView.register(UINib(nibName: NibIdentifier.routeFilterView.rawValue, bundle: nil), forCellWithReuseIdentifier: RoadTypeFilterCollectionViewCell.identifier)
        filterCollectionView.register(UINib(nibName: NibIdentifier.filterHeader.rawValue, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NibIdentifier.filterHeader.rawValue)
        
        let flow = filterCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.headerReferenceSize = CGSize(width: 300, height: 60)
        self.isTripsFilter = isTripsFilter
        self.setupView()
    }
    //MARK: Life Cycle -- constructors
    override func awakeFromNib(){
       // self.setupView()
    }
 
    //MARK: Private Methods
    private func setupView(){
        self.clearSelectionButton.characterSpace(space: -0.6)
        self.doneButton.characterSpace(space: -0.5)
        
        self.addTopRoundedCorner()
        self.addShadow()
        sectionNames = isTripsFilter ? ["Select the category"] : ["Select the type", "Select the level"]
    }
    
    private func addShadow(){
        self.addShadowWithColor(color: UIColor.shadow(), opacity: 5.0, offset: CGSize(width: 2, height: -5), radius: 5.0)
    }
    
    private func addTopRoundedCorner(){
        self.layer.cornerRadius = 10.0
    }
    // routes road type
    private func fillFilters(){
        self.filters.append(RouteFilter(color: UIColor.routeEasyColor(), isSelected: isSelectedFilter(roadType: .easy), title: easyRoad, logo: icRoadlevel))
        self.filters.append(RouteFilter(color: UIColor.routeIntermidiateColor(), isSelected: isSelectedFilter(roadType: .intermediate), title: intermediateRoad, logo: icRoadlevel))
        self.filters.append(RouteFilter(color: UIColor.routeDificultColor(), isSelected: isSelectedFilter(roadType: .difficult), title: difficultRoad, logo: icRoadlevel))
        self.filters.append(RouteFilter(color: UIColor.routeProColor(), isSelected: isSelectedFilter(roadType: .pro), title: proRoad, logo: icRoadlevel))
    }
    // completed/popular routes
    private func fillRouteTypeFilters(){
        self.routeTypeFilters.append(RouteFilter(color: UIColor.filterLime(), isSelected: isSelectedFilter(roadType: .completed), title: completedRoutes, logo: icCompletedRoute))
        self.routeTypeFilters.append(RouteFilter(color: UIColor.filterLime(), isSelected: isSelectedFilter(roadType: .popular), title: popularRoutes, logo: icPopularRoute))
    }
    // user trips filters
    private func fillTripFilters(){
        if let availableCategories = categories{
            for category in availableCategories{
                self.filters.append(RouteFilter(color: UIColor.clear, isSelected: isCategorySelected(id: "\(category.categoryId)"), title: category.name, logo: category.logo ?? icTripFilter))
            }
            self.filters.append(RouteFilter(color: UIColor.clear, isSelected: self.isWishFilterOn, title: "Show wishes", logo: icTripFilter))
        }
    }
    private func isSelectedFilter(roadType: RoadType) -> Bool{
        return self.selectedFilters.contains(roadType)
    }
    private func isDrivingModeSelected(mode: TripType) -> Bool{
        return self.selectedDrivingModes.contains(mode)
    }
    private func isCategorySelected(id: String) -> Bool{
        return self.selectedCategoryIds.contains(id)
    }
    private func display(_ onView: UIView){
        self.alpha = 0.0
        onView.addSubview(self)
        
        let h = UIScreen.main.bounds.size.height - 80
        let iPhoneX = Devices.deviceName() == Model.iPhoneX.rawValue ? true : false
        let height = iPhoneX ? h : h + 35.0
        let y = iPhoneX ? 80 - 35 : 80
        
        self.frame.size.height = height
        self.frame.origin.y = CGFloat(y)
        // display the view
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }, completion: nil
        )
    }
    //MARK: Helper
    class func fromNib<T : MapFilterView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    func displayView(onView: UIView, completionHandler: @escaping FilterCloseHandler) {
        
        self.handler = completionHandler
       display(onView)
    }
    func displayTripFilterView(onView: UIView, completionHandler: @escaping TripsFilterCloseHandler) {
        
        tripFilterHandler = completionHandler
        display(onView)
    }
    func hideView() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (finished) -> Void in
            self.removeFromSuperview()
            
        }
    }
    
    //MARK: IBAction Methods
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        self.hideView()
        let action: FilterAction
        if sender.tag == 100{ // close button
            action = FilterAction.close
        }else{ // done button
            action = FilterAction.done
        }
        //Route filter
        if let actionAandler = self.handler{
            let filterString = self.selectedFilters.map({"\($0.rawValue)"}).joined(separator: ",")
            actionAandler(action, filterString)
        }
        // Trip filter
        if let actionHandler = self.tripFilterHandler{
            //let modeFilterString = self.selectedDrivingModes.map({"\($0.rawValue)"}).joined(separator: ",")
            let idString = selectedCategoryIds.map( {"\($0)"}).joined(separator: ",")
            actionHandler(action, idString, isWishFilterOn)
        }
    }
    
    @IBAction func clearSelectionButtonTapped(_ sender: Any) {
        for item in self.filters{
            item.isSelected = false
        }
        for item in routeTypeFilters{
            item.isSelected = false
        }
        self.filterCollectionView.reloadData()
        isLiveTripOn = nil
        selectedCategoryIds.removeAll()
        selectedDrivingModes.removeAll()
        selectedFilters.removeAll()
    }

}
