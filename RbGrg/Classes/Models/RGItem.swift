//
//  RGItem.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/13/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import Foundation

class RGItem {
    
    init() {
        self.id = Int()
        self.title = nil
        self.itemDescription = nil
        self.price = nil
        self.currencyCode = nil
        self.images = RGImage()

    }
    
    init(id: Int, title: String, description: String, price: String, currency: String) {
        self.id = id
        self.title = title
        self.itemDescription = description
        self.price = price
        self.currencyCode = currency
        self.images = RGImage()
    }
    
    var title: String? = nil
    var id: Int
    var itemDescription: String? = nil
    var price: String? = nil
    var currencyCode: String? = nil
    var images: RGImage = RGImage()
}
