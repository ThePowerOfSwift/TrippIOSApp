//
//  AddTripWaypoint+TableView.swift
//  Tripp
//
//  Created by Monu on 21/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension TripWaypointViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.waypoints.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return (self.expandedIndexPath?.item == indexPath.item) ? 376.0 : 133.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RouteWaypointCell.cellIdentifier, for: indexPath) as! RouteWaypointCell
        self.populateWaypointCell(cell: cell, indexPath: indexPath)
        cell.closeExpandButton.isHidden = tableView.isEditing
        return cell
    }
    
    //-- Delete Row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.showDeleteConfirmAlert(atIndexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return isSwipeToDelete ? .delete : .none
    }
    
    //-- Move / Rearrange cell
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveWayPoint = self.waypoints[sourceIndexPath.item]
        self.waypoints.remove(at: sourceIndexPath.item)
        self.waypoints.insert(moveWayPoint, at: destinationIndexPath.item)
        self.waypointTableView.reloadData()
        if let delegate = self.delegate {
            delegate.moveWaypoint(from: sourceIndexPath.item, to: destinationIndexPath.item)
        }
    }
    
    private func populateWaypointCell(cell: RouteWaypointCell, indexPath: IndexPath){
        let waypoint = self.waypoints[indexPath.item]
        
        //-- Show hide media
        cell.mediaView.isHidden = (self.expandedIndexPath?.item == indexPath.item) ? false : true
        cell.mediaCollectionView.mediaMode = .addMedia
        cell.populateCell(waypoint: waypoint, indexPath: indexPath, isShowMedia: !cell.mediaView.isHidden)
        cell.mediaCollectionView.isHidden = waypoint.waypointMedia.count <= 0 ? true : false
        self.showPointName(atIndex: indexPath, cell: cell)
    }
    
    private func showPointName(atIndex: IndexPath, cell: RouteWaypointCell){
        if atIndex.item == 0 {
            cell.pointNameLabel.text = startingPointMessage
            cell.pointLogo.image = UIImage(named: icStartPoint)
        }
        else if atIndex.item == self.waypoints.count-1 {
            cell.pointNameLabel.text = finalPointMessage
            cell.pointLogo.image = UIImage(named: icFinalPoint)
        }
        else{
            cell.pointNameLabel.text = waypointMessage
            cell.pointLogo.image = UIImage(named: icWayPoint)
        }
    }
    
    //MARK: IBAction Methods
    @IBAction func closeExpandButtonTapped(_ sender: UIButton) {
        if let indexPath = self.expandedIndexPath {
            if indexPath.item != sender.tag{
                self.expandedIndexPath = nil
                self.waypointTableView.reloadRows(at: [indexPath], with: .fade)
                self.expandedIndexPath = IndexPath(item: sender.tag, section: 0)
                self.waypointTableView.reloadRows(at: [self.expandedIndexPath!], with: .fade)
            }
            else{
                self.expandedIndexPath = nil
                self.waypointTableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        else{
            self.expandedIndexPath = IndexPath(item: sender.tag, section: 0)
            self.waypointTableView.reloadRows(at: [self.expandedIndexPath!], with: .fade)
        }
        
    }
    
    //MARK: Gesture On Table View
    func enableLongPressOnTableView(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(TripWaypointViewController.longPress(_:)))
        self.waypointTableView.addGestureRecognizer(longPressGesture)
    }
    
    private func enableTapOnTableView(){
        let tapPressGesture = UITapGestureRecognizer(target: self, action: #selector(TripWaypointViewController.longTap(_:)))
        self.waypointTableView.addGestureRecognizer(tapPressGesture)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
        self.isSwipeToDelete = false
        self.waypointTableView.setEditing(true, animated: true)
        self.waypointTableView.removeGestureRecognizer(sender)
        self.expandedIndexPath = nil
        self.waypointTableView.reloadData()
        enableTapOnTableView()
    }
    
    @objc func longTap(_ sender: UITapGestureRecognizer){
        self.isSwipeToDelete = true
        self.waypointTableView.setEditing(false, animated: true)
        self.waypointTableView.removeGestureRecognizer(sender)
        self.waypointTableView.reloadData()
        enableLongPressOnTableView()
    }
    
    func showDeleteConfirmAlert(atIndexPath:IndexPath){
        let alert = AddRoutesAlertPopupView(removeWaypointWarning, actionButtonTitle: continueTitle) { buttonIndex in
            if buttonIndex == 2{
                self.waypoints.remove(at: atIndexPath.item)
                self.waypointTableView.reloadData()
                self.displayInitialPoint()
                if let delegate = self.delegate {
                    delegate.deleteWaypoint(atIndex: atIndexPath.item)
                }
            }
        }
        alert.displayView(onView: windowGlobal != nil ? windowGlobal! : self.view)
    }
}
