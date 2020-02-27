//
//  FeedData.swift
//  Tripp
//
//  Created by Bharat Lal on 13/05/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import Foundation
import RealmSwift

class FeedData: Feed {

    @objc dynamic var isLiked: Int = 0
    @objc dynamic var totalLikeCount = 0
    @objc dynamic var user: AppUser?
    @objc dynamic var trip: Route?
}
extension FeedData {
    func toggleLike(_ completionHandler: @escaping (_ message: String?, _ error: String?)-> Void) {
        APIDataSource.toggleLike(service: .likeFeed(feedId: feedId)) { [weak self] (message, error) in
            
            if error == nil {
                let counter = self?.isLiked == 1 ? -1 : 1
                self?.totalLikeCount += counter
                self?.isLiked = self?.isLiked == 1 ? 0 : 1
            }
            
            completionHandler(message, error)
        }
    }
}
