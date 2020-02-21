//
//  TripManager.swift
//  Tripp
//
//  Created by Bharat Lal on 31/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

typealias TripComplitionHandler = (_ route: Route?, _ error: Error?) ->()
class TripsManager: NSObject{
    
    var handler: TripComplitionHandler?
    var currentPage = 1
    var totalPage = 0
    var isContinue = true
    var categoryId: String? = nil
    var userId: Int?
    
    lazy var googleDirectionForTripQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Google Direction For Trips Queue"
        return queue
    }()
    
    
    lazy var offlineRouteTripQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Offline Route Trips Queue"
        return queue
    }()
    
   
    /**
     * @method startFetchingTripps
     * @discussion start fetching tripps
     */
    func startFetchingTripps(drivingMode: String? = nil, isLive: Bool? = nil , categoryId: String? = nil, userId: Int? = nil, _ handler: @escaping RouteComplitionHandler){
        self.handler = handler
        self.categoryId = categoryId
        self.userId = userId
        self.fetchTrips(drivingMode, isLive, categoryId: categoryId, userId: userId)
    }
    /**
     * @method polylineForTrip
     * @discussion get polyline for a given route(trip)
     */
    func polylineForTrip(_ trip: Route, _ handler: @escaping RouteComplitionHandler){
        self.handler = handler
        self.addRouteInQueue(trip)
    }
    func syncOfflineTrip(_ trip: OfflineRoute) {
        let operation = SyncOfflineOperation(trip: trip, handler: { (route, error) in
           // self.completeOperation(route: route)
        })
        offlineRouteTripQueue.addOperation(operation)
    }
 
    private func fetchTrips(_ drivingMode: String? = nil, _ isLive: Bool? = nil,  categoryId: String? = nil, userId: Int? = nil){
        APIDataSource.fetchRoutes(.fetchTrips(page: self.currentPage, drivingMode: drivingMode, isLive: isLive, categoryId: categoryId, userId: userId)) { (routes, totalPage, perPageCount, error) in
            if let _ = error {
                return
            }
            self.currentPage += 1
            self.addPolylineOperationInQueue(routes: routes!)
            self.totalPage = totalPage!
            self.checkNextPage()
        }
    }
    /**
     * @method addPolylineOperationInQueue
     * @discussion add Polyline Operation In Queue
     */
    private func addPolylineOperationInQueue(routes: [Route]){
        for route in routes {            
            self.addRouteInQueue(route)
        }
    }
    private func addRouteInQueue(_ route: Route){
        let operation = GoogleDirectionAPIOperation(route, completionHnadler: { route in
            self.completeOperation(route: route)
        })
        googleDirectionForTripQueue.addOperation(operation)
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
    private func checkNextPage(){
        if isContinue == true && self.currentPage <= self.totalPage{
            self.fetchTrips(categoryId: self.categoryId)
        }
    }
    /**
     * @method pauseAllOperations
     * @discussion pause All Operations
     */
    public func pauseAllOperations(){
        self.isContinue = false
        self.googleDirectionForTripQueue.isSuspended = true
    }
    public func cancelAllOperations(){
        APIDataSource.stopAllSessions()
        self.googleDirectionForTripQueue.cancelAllOperations()
    }
    /**
     * @method resumeAllOperations
     * @discussion resume All Operations
     */
    public func resumeAllOperations(){
        self.isContinue = true
        self.googleDirectionForTripQueue.isSuspended = false
        self.checkNextPage()
    }
    
}
