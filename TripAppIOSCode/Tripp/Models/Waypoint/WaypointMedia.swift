//
//  WaypointMedia.swift
//  Tripp
//
//  Created by Bharat Lal on 13/07/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift
enum MediaType: Int {
    case photo = 1
    case video  = 2
}
class WaypointMedia: Object {

    @objc dynamic var mediaId = 0
    @objc dynamic var type = MediaType.photo.rawValue
    @objc dynamic var caption = ""
    @objc dynamic var sourcePath = ""
    @objc dynamic var createdAt = ""
    @objc dynamic var address: String?
    @objc dynamic var city: String?
    @objc dynamic var state: String?
    @objc dynamic var country: String?
    @objc dynamic var latitude: String?
    @objc dynamic var longitude: String?
    
//    override static func primaryKey() -> String? {
//        return "mediaId"
//    }

}
