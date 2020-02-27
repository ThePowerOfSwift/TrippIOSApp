//
//  Paging.swift
//  Tripp
//
//  Created by Bharat Lal on 13/05/18.
//  Copyright © 2018 Appster. All rights reserved.

import Foundation
import RealmSwift

public class Paging: Object {

    // MARK: Properties
    @objc dynamic var total = 0
    @objc dynamic var perPage = 0
    @objc dynamic var lastPage = 0
    @objc dynamic var currentPage = 0

}
