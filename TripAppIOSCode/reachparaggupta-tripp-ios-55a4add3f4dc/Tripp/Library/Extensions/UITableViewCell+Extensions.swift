//
//  UITableViewCell+Extensions.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {

    public func viewControllerOfCell() -> UIViewController { // get view controller of the cell
        var view = self as UIView
        while !view.superview!.isKind(of: UITableView.self) {
            view = view.superview!
        }
        let tableView = view.superview as! UITableView
        let viewController = tableView.dataSource as! UIViewController

        return viewController
    }

    public func tableView() -> UITableView { //Get tableview of the cell
        var view = self as UIView
        while !view.superview!.isKind(of: UITableView.self) {
            view = view.superview!
        }
        let tableView = view.superview as! UITableView

        return tableView
    }
    
    static var cellIdentifier: String {
        return String(describing: self)
    }

}
