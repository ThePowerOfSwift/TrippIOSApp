//
//  PlaceDetailsViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 24/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
import GoogleMaps
class PlaceDetailsViewController: UIViewController {
    @IBOutlet weak var placeName: CharacterSpaceLabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var markCompleteButton: UIButton!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addToWishButton: RoundedBorderButton!
    @IBOutlet weak var activeImageView: UIImageView!
    @IBOutlet weak var stackViewWidth: NSLayoutConstraint!
    var place: Place!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     // MARK: - Private
    private func setup(){
        mapView.layer.cornerRadius = 9.0
        mapView.clipsToBounds = true
        mapView.delegate = self
        dropMarkerOn(place)
        details.text = place.about
        placeName.text = place.name
        checkPlaceUserStatus()
        addToWishButton.changeBorderColor(color: UIColor.blueButtonColor(), borderRadius: 22)
        loadDetails()
    }
    private func checkPlaceUserStatus() {
        markCompleteButton.isSelected = place.isMarkedAsComplete == 1
        addToWishButton.isHidden = place.isAddedToWishlist == 1
    }
    private func dropMarkerOn(_ place: Place) {
        guard let lat = Double(place.latitude), let long =  Double(place.longitude) else {
            return
        }
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let location = CLLocation(latitude: lat, longitude: long)
        self.mapView.moveMapToUserlocation(location)
        let marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "icWayponiMarker")
        marker.map = self.mapView
    }
    private func loadDetails() {
        AppLoader.showLoader()
        APIDataSource.fetchPlaceWithImages(service: .placeDetails(placeId: place.placeId)) { [weak self] (place, error) in
            AppLoader.hideLoader()
            if let placeWithImages = place {
                self?.place = placeWithImages
                self?.reloadImages()
            }
        }
    }
    private func  reloadImages() {
        imageCollectionView.reloadData()
        reloadStackView()
        checkPlaceUserStatus()
    }
    private func  reloadStackView() {
        let arrangedSubviews = stackView.arrangedSubviews
        for v in arrangedSubviews {
            stackView.removeArrangedSubview(v)
        }
        let pages = place.images.count == 0 ? 1 : place.images.count
        stackViewWidth.constant = CGFloat(21 * pages)
        for index in 0 ..< pages {
            if index == 0{
                stackView.insertArrangedSubview(activeImageView, at: index)
            }else{
                stackView.insertArrangedSubview(UIImageView(image: UIImage(named: "pageDotNonSelected")), at: index)
            }
        }
    }
    // MARK: - IBActions
    @IBAction func markAsCompletedTapped(_ sender: UIButton) {
        sender.isSelected = true
        AppLoader.showLoader()
        APIDataSource.markPlaceAsComplete(service: .markPlaceAsCompleted(placeId: place.placeId)) { (message, error) in
            AppLoader.hideLoader()
            if let err = error {
                AppToast.showErrorMessage(message: err)
                sender.isSelected = false
            } else {
                AppToast.showSuccessMessage(message: message ?? "Place added to your visited list.")
            }
        }
    }
    @IBAction func addToWishTapped(_ sender: UIButton) {
        AppLoader.showLoader()
        APIDataSource.addPlaceToWishList(service: .addPlaceoWishlist(placeId: place.placeId)) { (message, error) in
            AppLoader.hideLoader()
            if let err = error {
                AppToast.showErrorMessage(message: err)
            } else {
                AppToast.showSuccessMessage(message: message ?? "Place added to your wish list.")
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
        stackView.insertArrangedSubview(activeImageView, at: index)
    }
}
extension PlaceDetailsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
         marker.openMap()
        return true
    }
}
