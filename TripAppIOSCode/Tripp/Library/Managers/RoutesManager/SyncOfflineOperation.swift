//
//  SyncOfflineOperation.swift
//  Tripp
//
//  Created by puneet on 13/11/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SyncOfflineOperation: Operation {

    var handler: TripComplitionHandler?
    var offlineTrip : OfflineRoute?
    
    required init(trip : OfflineRoute, handler: TripComplitionHandler?) {
        self.handler = handler
        self.offlineTrip = trip
        super.init()
    }
    
    override func main() {
        if self.isCancelled{
            return
        }
        
       // saveOfflineTrip()
    }

}
