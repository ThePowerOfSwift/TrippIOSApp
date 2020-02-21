//
//  GoogleDirectionAPIOperation.swift
//  Tripp
//
//  Created by Bharat Lal on 06/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class GoogleDirectionAPIOperation: Operation {

    var route: Route?
    typealias GoogleOperationHandler = (_ route: Route) -> ()
    var handler: GoogleOperationHandler?
    required init(_ route: Route, completionHnadler: @escaping GoogleOperationHandler){
        self.route = route
        self.handler = completionHnadler
        super.init()
    }
    
    override func main(){
        if self.isCancelled{
            return
        }
        
        if route?.tripMode == TripMode.Live.rawValue{
            self.fetchLiveTripPath()
        }
        else if self.route?.drivingMode == TripType.Road.rawValue {
            fetchPath()
        }
        else{
            self.handler!(self.route!)
        }
    }
    
    /**
     * @method fetchPath
     * @discussion fetch Path(polyline) from Google direction API
     */
    func fetchPath(){
        guard let aRoute = self.route else {
            return
        }
        
        if aRoute.waypoints.count < 2{
            return
        }
        APIDataSource.fetchRoutePolylineFrom((aRoute.waypoints.first?.coordinates())!, destination: (aRoute.waypoints.last?.coordinates())!, waypoints: route?.waypointsCoordinates()) { googlePath in
            self.route?.polylineString = googlePath?.polyline
            if let _ = self.handler, googlePath?.polyline != nil {
                self.handler!(self.route!)
            }
        }
    }
    func fetchLiveTripPath(){
        guard let fileName = self.route?.fileUrl else {
            return
        }
        
        AWSImageManager.sharedManger.downloadFileFromS3(fileName) { (status, fileUrl) in
            if let url = fileUrl {
                do{
                    let routePathString = try String(contentsOf: url)
                    self.route?.polylineString = routePathString as NSString
                    if let _ = self.handler, self.route?.polylineString != nil {
                        self.handler!(self.route!)
                    } else {
                        DLog(message: "google rrrr" as AnyObject)
                    }
                }
                catch{
                    // Do nothing
                    DLog(message: "google rrrr exce" as AnyObject)
                }
            }
        }
    }
}
