//
//  CategoryManager.swift
//  Tripp
//
//  Created by Bharat Lal on 18/09/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
class CategoryManager{
    static let sharedManager = CategoryManager()
    
    fileprivate var categories = [Category]()
    
    
    func fetchCategories(completion: @escaping (_ categories:[Category]?, _ error: String?) -> ()) {
        if categories.count > 0 {
            completion(self.categories, nil)
        }
        else{
            APIDataSource.fetchCategories(handler: { (categories, error) in
               
                if let responseCategories = categories {
                    self.categories = responseCategories
                    completion(self.categories, nil)
                }
                else{
                    completion(nil, error)
                }
            })
        }
    }
    func categoryById(_ id: Int, handler: @escaping (_ category: Category?) -> ()) {
        if categories.count > 0 {
            let category = categories.filter( {$0.categoryId == id }).first
            handler(category)
        }else{
            fetchCategories(completion: { (categories, error) in
                if let responseCategories = categories {
                    handler(responseCategories.filter( {$0.categoryId == id }).first)
                }
                else{
                    handler(nil)
                }
            })
        }
    }
}
