//
//  Garment.swift
//  Lulu
//
//  Created by Rohan Aurora on 8/31/20.
//  Copyright © 2020 Rohan Aurora. All rights reserved.
//

import Foundation

struct Garment {
    var itemID: Int = 0
    var itemName: String = ""
    var itemDate: Int = 0
    
    init(id: Int, name: String, date: Int) {
        self.itemID = id
        self.itemName = name
        self.itemDate = date
    }
}
