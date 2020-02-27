//
//  Realm+Extensions.swift
//  Tripp
//
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift


extension Object {
    
    @objc func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        
        for prop in self.objectSchema.properties as [Property]! {
            // find lists
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            } else if let nestedListObject = self[prop.name] as? ListBase {
                var objects = [AnyObject]()
                for index in 0..<nestedListObject._rlmArray.count  {
                    let object = nestedListObject._rlmArray[index] as AnyObject
                    objects.append(object.toDictionary())
                }
                mutabledic.setObject(objects, forKey: prop.name as NSCopying)
            }
        }
        return mutabledic
    }
    
    func saveObject(){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
    }
}

extension Realm {
    
    //Delete Table Data
    class func truncateTable<T>(_ type: T.Type) {
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                let objects =  realm.objects(type as! Object.Type)
                realm.delete(objects)
            })
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
    }
    
}

class RealmString : Object {
    
}
