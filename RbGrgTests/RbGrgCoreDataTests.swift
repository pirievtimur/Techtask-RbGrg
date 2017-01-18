//
//  RbGrgCoreDataTests.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/18/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import XCTest

@testable import RbGrg

class RbGrgCoreDataTests: XCTestCase {
    
    var coreDataService: RGCoreDataService!
    var item: RGItem = RGItem()
    
    override func setUp() {
        super.setUp()
        
        coreDataService = RGCoreDataService()
        
        item = RGItem.init(id: 123, title: "Test", description: "Description", price: "123", currency: "UAH")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCoreDataSaving() {
        coreDataService.storeItem(item: item)
        XCTAssert(coreDataService.itemWithId(id: 123) == true)
    }

    func testCoreDataDeleteItem() {
        coreDataService.deleteItem(item: item)
        XCTAssert(coreDataService.itemWithId(id: 123) == false)
    }
}
