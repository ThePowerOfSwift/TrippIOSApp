//
//  MyProfileViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 23/06/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MyProfileViewController: UIViewController {
    //MARK: Variables/IBOutlets
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var bikeTypeView: UIView!
    @IBOutlet weak var bikeMakeView: UIView!
    @IBOutlet weak var bikeModelView: UIView!
    @IBOutlet weak var bikeYearView: UIView!
    @IBOutlet weak var bikeDetailsParentView: UIView!
    @IBOutlet weak var pageStackView: UIStackView!
    @IBOutlet weak var activeImageView: UIImageView!
    @IBOutlet weak var nameLabel: CharacterSpaceLabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var bikeTypeLabel: UILabel!
    @IBOutlet weak var bikeMakeLabel: UILabel!
    @IBOutlet weak var bikeYearLabel: UILabel!
    @IBOutlet weak var bikeModelLabel: UILabel!
    @IBOutlet weak var nameField: BottomBorderTextField!
    @IBOutlet weak var editNameButton: UIButton!
    @IBOutlet weak var editVehicleButton: UIButton!
    @IBOutlet weak var pageStackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: CharacterSpaceLabel!
    @IBOutlet weak var vehicleInfoLabel: CharacterSpaceLabel!
    @IBOutlet weak var wishListIconView: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var topRightButton: UIButton!
    
    var tripInformations : [(number:String, info:String, logo:String)] = []
    var userName = ""
    var groupMember: GroupMember?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let member = groupMember {
            setupviewAsGroupMember(member)
        } else {
            fillProfileInfo(AppUser.currentUser())
            //self.perform(#selector(MyProfileViewController.fetchStats), with: nil, afterDelay: 1.0)
            fetchStats()
        }
        AdMobManager.checkAndUpdateBanner(self.bannerView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - setup
    @objc private func fetchStats(){
        APIDataSource.userStatistic(service: .userProfile(userId: nil)) { [weak self] (user, error) in
            if let anUser = user{
                AppUser.currentUser().updateUser(user: anUser)
                self?.populateInfo(anUser)
            }
        }
    }
    

    func setupView(){
        self.headerView.backgroundColor = .clear
        self.bikeMakeView.addRightBorder()
        self.bikeTypeView.addRightBorder()
        self.bikeModelView.addRightBorder()
        self.bikeDetailsParentView.layer.borderColor = UIColor.colorWith(0, 183, 234, 0.43).cgColor
        setupNameField()
        // populateInfo()
        AdMobManager.loadBanner(self.bannerView, rootViewController: self)
    }
    func setupNameField(){
        self.nameField.isHidden = true
        self.nameLabel.isHidden = false
        self.nameLabel.numberOfLines = 0
        self.nameField.border.isHidden = true
        self.nameField.setCharacterSpace(space: 0.7)
        self.nameField.isUserInteractionEnabled = false
        self.nameField.addDoneOnKeyboardWithTarget(self, action: #selector(MyProfileViewController.keyboardDoneAction))
    }
    func populateInfo(_ user: AppUser){
        self.tripInformations.removeAll()
        DLog(message: "wishlist count is\(user.wishlistCount)" as AnyObject)
        
        self.wishListIconView.isHidden = true
        if user.wishlistCount > 0 && groupMember == nil {
            self.wishListIconView.isHidden = false
        }
        
        tripInformations.append((number: user.statesTraveled.description, info: TripInfo.statesTraveled, logo: icRoadIcon))
        tripInformations.append((number: user.countriesTraveled.description, info: TripInfo.countriesTraveled, logo: icTopRoadIcon))
        tripInformations.append((number: user.easyRouteTraveled.description, info: TripInfo.easyRoadsTraveled, logo: icAdvanceRoadIcon))
        tripInformations.append((number: user.intermediateRouteTraveled.description, info: TripInfo.intermediateRoadsTraveled, logo: icRoadIcon))
        tripInformations.append((number: user.difficultRouteTraveled.description, info: TripInfo.difficultRoadsTraveled, logo: icTopRoadIcon))
        tripInformations.append((number: user.proRouteTraveled.description, info: TripInfo.proRoadsTraveled, logo: icAdvanceRoadIcon))
        
        // category stats
        for categoryStats in user.categoryStats{
            tripInformations.append((number: categoryStats.totalDistance.description, info: categoryStats.name, logo: icAdvanceRoadIcon))

        }
        
        let arrangedSubviews = pageStackView.arrangedSubviews
        for v in arrangedSubviews{
            pageStackView.removeArrangedSubview(v)
        }
        let count = user.categoryStats.count
        let totalStats = Double(6 + count)
        let pages = Int(ceil(totalStats/3.0))
        pageStackViewWidth.constant = CGFloat(21 * pages)
        for index in 0 ..< pages {
            if index == 0{
            pageStackView.insertArrangedSubview(activeImageView, at: index)
            }else{
                pageStackView.insertArrangedSubview(UIImageView(image: UIImage(named: "pageDotNonSelected")), at: index)
            }
        }
        
        // add extra cell if not dividable by 3
        let reminder = Int(totalStats.truncatingRemainder(dividingBy: 3.0))
        if reminder != 0 {
            let extraCell = 3 - reminder
            for _ in 0..<extraCell {
                tripInformations.append((number: "", info: "", logo: ""))
            }
        }
        self.profileTableView.reloadData()
    }
    func fillProfileInfo(_ user: AppUser){
        self.nameLabel.text = user.fullName
        if user.fullName.isEmpty{
            self.nameLabel.text = "No name"
        }
        self.setProfileImage(user)
        if let bike = user.vehicle{
            self.fillBikeView(bike: bike)
        }
    }
    func setProfileImage(_ user: AppUser){
        let profle = user.profileImage
        
        if !profle.isEmpty{
            self.profileImageButton.imageFromS3(profle, handler: nil)
        }
    }
    func fillBikeView(bike: Vehicle){
        self.bikeTypeLabel.text = bike.type
        self.bikeMakeLabel.text = bike.make
        self.bikeModelLabel.text = bike.model
        self.bikeYearLabel.text = bike.manufacturingYear
    }
    // MARK: - IBActions
    @IBAction func updateImageTapped(_ sender: CircularButton) {
        if groupMember == nil {
            self.openImagePickerController(sender: sender)
        }
        
    }
    @IBAction func wishListTapped(_ sender: Any) {
        if let member = groupMember {
            showMemberTripView(member)
        } else {
            presentWishList()
        }
        
    }
    @IBAction func updateNameTapped(_ sender: Any) {
        self.nameField.isUserInteractionEnabled = true
        self.editNameButton.isHidden = true
        self.nameLabel.isHidden = true
        self.nameField.isHidden = false
        self.userName = self.nameLabel.text!
        if AppUser.currentUser().fullName.isEmpty == false{
            self.nameField.text = self.userName
        }
        self.nameField.becomeFirstResponder()
    }
    @IBAction func updateVehicleTapped(_ sender: UIButton) {
        
        let profile = Profile.createProfileFromUserWithImage(self.profileImageButton.currentImage!)
        self.presentAddVehical(profile: profile)
    }
    //MARK: -- keyboard done button action
    @objc func keyboardDoneAction(){
        self.nameField.isUserInteractionEnabled = false
        self.nameLabel.isHidden = false
        self.nameField.isHidden = true
        self.editNameButton.isHidden = false
        if self.nameField.isEmpty(){
            self.nameLabel.text = userName
        }else if !Validation.isAlphaNumeric(text: self.nameField.text!){
            AppToast.showErrorMessage(message: fullNameValidation)
            self.nameLabel.text = userName
            
        }else{
            
            if self.nameLabel.text != self.nameField.text! {
                //update API call
                AppLoader.showLoader()
                self.nameLabel.text = self.nameField.text!
                APIDataSource.updateProfile(service: .updateUserName(name: self.nameLabel.text!), handler: { (user, error) in
                    AppLoader.hideLoader()
                    if isGuardObject(user) {
                        AppUser.currentUser().updateUser(user: user!)
                        AppToast.showSuccessMessage(message: nameUpdated)
                    }
                    else{
                        AppToast.showErrorMessage(message: error!)
                    }
                })
            }
        }
        
    }
    
}
