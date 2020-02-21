//
//  WishRoutesManager.swift
//  Tripp
//
//  Created by Bharat Lal on 29/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import GoogleMaps

typealias WishRoutesComplitionHandler = (_ route: Route?, _ error: Error?) ->()
class WishRoutesManager: NSObject{
    
    var handler: WishRoutesComplitionHandler?
    
    lazy var googleDirectionForWishTripQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Google Direction For wish Trips Queue"
        return queue
    }()
    
    /**
     * @method startFetchingTripps
     * @discussion start fetching tripps
     */
    func startFetchingWishes(_ handler: @escaping WishRoutesComplitionHandler){
        self.handler = handler
        self.fetchTrips()
    }
    /**
     * @method polylineForTrip
     * @discussion get polyline for a given route(trip)
     */
    
    private func fetchTrips(){
        APIDataSource.userWishList(service: .wishList) { (wishList, error) in
            if let wishes = wishList {
                self.addPolylineOperationInQueue(wishes: wishes)
            }
            
        }
        
    }
    /**
     * @method addPolylineOperationInQueue
     * @discussion add Polyline Operation In Queue
     */
    private func addPolylineOperationInQueue(wishes: [WishList]){
        for wish in wishes {
            self.addRouteInQueue(wish)
        }
    }
    private func addRouteInQueue(_ wish: WishList){
        let route = Route.routeFromWish(wish)
        let operation = GoogleDirectionAPIOperation(route, completionHnadler: { route in
            self.completeOperation(route: route)
        })
        googleDirectionForWishTripQueue.addOperation(operation)
    }
    
    //-- Final operation response
    private func completeOperation(route: Route){
        if let _ = self.handler {
            self.handler!(route, nil)
        }
    }
    
}
