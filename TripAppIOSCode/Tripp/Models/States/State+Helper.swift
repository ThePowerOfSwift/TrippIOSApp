//
//  State+Helper.swift
//  Tripp
//
//  Created by Bharat Lal on 08/08/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import RealmSwift

extension State{
    // update clone in a database as realm need write block to do this
    func clone() -> State {
        let state = State()
        state.stateId = self.stateId
        state.name = self.name ?? ""
        state.country = self.country
        state.lat = self.lat ?? ""
        state.lon = self.lon ?? ""
        return state
    }
    //update user when edit user details
    func saveState() {
        do {
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(self.clone(), update: true)
                
            })
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }        
    }
    
    //Array Of states
    class func statesArray() -> [State]? {
        do{
            let results = try Realm().objects(State.self)
            return Array(results)
            
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
            return nil
        }
    }
    
    //delete user
    class func clearStates() {
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                let objects = try Realm().objects(State.self)
                realm.delete(objects)
            })
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
        }
        
    }
    //search state
    class func searchWithText(text: String) -> [State]? {
        do{
            let predicate = NSPredicate(format: "name contains[c] %@", text)
            let realm = try Realm()
            let states = realm.objects(State.self).filter(predicate)
            return Array(states)
        }catch{
            DLog(message: "Realm error: Something went wrong" as AnyObject)
            return nil
        }
        
    }
}
