//
//  DataManager.swift
//  Lulu
//
//  Created by Rohan Aurora on 8/31/20.
//  Copyright © 2020 Rohan Aurora. All rights reserved.
//

import UIKit

struct DataManager {
    var db = Database()
    var data: [Garment]?
    
    public init() { }
    
    public func insertItem(id:Int, name:String, date:Int) {
        db.insert(id: id, name: name, date: date)
    }
    
    public func sortByDate(_ sort: OrderState) -> [Garment] {
        if db.read().count == 0 {
            db.insert(id: 0, name: "Dress", date: 2019)
            db.insert(id: 1, name: "Pant", date: 2019)
            db.insert(id: 2, name: "Shirt", date: 2012)
            db.insert(id: 3, name: "Tshirt", date: 2014)
        }
        return db.sortBy(state: sort)
    }
}






