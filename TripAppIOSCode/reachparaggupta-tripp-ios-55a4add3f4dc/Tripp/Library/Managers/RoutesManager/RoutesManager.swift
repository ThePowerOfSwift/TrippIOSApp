//
//  RoutesManager.swift
//  Tripp
//
//  Created by Bharat Lal on 05/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

typealias RouteComplitionHandler = (_ route: Route?, _ error: Error?) ->()
class RoutesManager: NSObject{
    
    var handler: RouteComplitionHandler?
    var currentPage = 1
    var latitude: String?
    var longitude: String?
    var totalPage = 0
    var isContinue = true
    
    lazy var googleDirectionQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Google Direction Queue"
        return queue
    }()
    /**
     * @method startFetchingRoutes
     * @discussion start fetching routes
     */
    func startFetchingRoutes(_ lat: String, _ lon: String, filter: String, _ handler: @escaping RouteComplitionHandler){
        
        if !Connection.isInternetConnected() {
            return
        }
        
        self.handler = handler
        self.latitude = lat
        self.longitude = lon
        self.fetchRoutesWith(filter: filter)
    }
    
    /**
     * @method polylineForTrip
     * @discussion get polyline for a given route(trip)
     */
    func polylineForTrip(_ trip: Route, _ handler: @escaping RouteComplitionHandler){
        self.handler = handler
        self.addRouteInQueue(trip)
    }
    private func fetchRoutesWith(filter: String){
        APIDataSource.fetchRoutes(.fetchRoutes(page: self.currentPage, lat: self.latitude!, lon: self.longitude!, filter: filter)) { (routes, totalPage, perPageCount, error) in
            if let _ = error {
                return
            }
            self.currentPage += 1
            self.addPolylineOperationInQueue(routes: routes!)
            self.totalPage = totalPage!
            self.checkNextPageWith(filter: filter)
        }
    }
    /**
     * @method addPolylineOperationInQueue
     * @discussion add Polyline Operation In Queue
     */
    private func addPolylineOperationInQueue(routes: [Route]){
        for route in routes {
            if Global.alreadyAddedRoutes.contains(route.tripId) {
                continue
            }
           
            self.addRouteInQueue(route)
        }
    }
    private func addRouteInQueue(_ route: Route){
        let operation = GoogleDirectionAPIOperation(route, completionHnadler: { route in
            self.completeOperation(route: route)
        })
        googleDirectionQueue.addOperation(operation)
    }
    
    //-- Final operation response
    private func completeOperation(route: Route){
        if let _ = self.handler {
            self.handler!(route, nil)
        }
    }
    /**
     * @method checkNextPage
     * @discussion check if next page available
     */
    private func checkNextPageWith(filter: String){
        if isContinue == true && self.currentPage <= self.totalPage{
            self.fetchRoutesWith(filter: filter)
        }
    }
    /**
     * @method pauseAllOperations
     * @discussion pause All Operations
     */
    public func pauseAllOperations(){
        self.isContinue = false
        self.googleDirectionQueue.isSuspended = true
    }
    public func cancelAllOperations(){
        APIDataSource.stopAllSessions()
        self.googleDirectionQueue.cancelAllOperations()
    }
    /**
     * @method resumeAllOperations
     * @discussion resume All Operations
     */
    public func resumeAllOperations(filters: String){
        self.isContinue = true
        self.googleDirectionQueue.isSuspended = false
        self.checkNextPageWith(filter: filters)
    }

}
