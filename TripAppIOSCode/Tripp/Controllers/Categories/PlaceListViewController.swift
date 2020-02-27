//
//  PlaceListViewController.swift
//  Tripp
//
//  Created by Bharat Lal on 24/09/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class PlaceListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension PlaceListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (parent as? PlacesViewController)!.places.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.identifier, for: indexPath) as! PlaceTableViewCell
        configureCellAt(indexPath, cell, tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let category = (parent as? PlacesViewController)?.category, category.isPurchased == 0 {
            presentCategoryIAPWith(category)
            return
        }
        if let place = (parent as? PlacesViewController)?.places[indexPath.row] {
            pushPlacesDetails(place)
        }
    }
    //MARK: helper
    fileprivate func configureCellAt(_ indexPath: IndexPath, _ cell: PlaceTableViewCell, _ tableView: UITableView) {
        let place = (parent as? PlacesViewController)!.places[indexPath.row]
        cell.placeName.text = place.name
        
        if let url = place.primaryImage, url.isEmpty == false{
            cell.placeImageView.imageFromS3(url, handler: { (image) in
                if let currentCell = tableView.cellForRow(at: indexPath) as? PlaceTableViewCell{
                    currentCell.placeImageView.image = image
                }
            })
        } else {
            cell.placeImageView.image = #imageLiteral(resourceName: "tripImagesCount")
        }
    }
}
