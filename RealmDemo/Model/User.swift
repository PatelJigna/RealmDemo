//
//  User.swift
//  RealmDemo
//
//  Created by Jigna Patel on 22.08.18.
//  Copyright © 2018 Jigna Patel. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var id = 0
    
    @objc dynamic var name: String? = nil
    var gender = RealmOptional<Int>()
    @objc dynamic var occupation: String? = nil
    var age = RealmOptional<Int>()
    var contact = RealmOptional<Int>()
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id:Int, name: String, gender:RealmOptional<Int>, occupation:String, age:RealmOptional<Int>, contact: RealmOptional<Int>)
    {
        self.init()
        self.id = id
        self.name = name
        self.gender = gender
        self.occupation = occupation
        self.age = age
        self.contact = contact
    }
    
}
