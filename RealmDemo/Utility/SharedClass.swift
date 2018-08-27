//
//  SharedClass.swift
//  RealmDemo
//
//  Created by Jigna Patel on 22.08.18.
//  Copyright © 2018 Jigna Patel. All rights reserved.
//

import Foundation
import RealmSwift


class SharedClass: NSObject {
    
    static var sharedInstance:SharedClass = SharedClass()
    
    let realm = try? Realm()
    
    //Save
    func saveRecord(obj: Object) {
        try? realm?.write {
            realm?.add(obj, update: false)
        }
    }
    
    
    //Update
    func updateRecord(obj: Object) {
        try? realm?.write {
            realm?.add(obj, update: true)
        }
    }
    
    
    //Delete
    func deleteAllRecord(obj: Object) {
        try? realm?.write {
            realm?.deleteAll()
        }
    }
    
    func deleteRecord(obj: Object) {
        try? realm?.write {
            realm?.delete(obj)
        }
    }
    
    //Get All Records
    
    func getAllRecords(type: Object.Type) -> Results<Object>? {
       return realm?.objects(type)
    }
    
    
    func incrementID() -> Int {
        return (realm!.objects(User.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    
}
