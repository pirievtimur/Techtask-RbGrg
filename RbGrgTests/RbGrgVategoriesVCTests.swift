//
//  RbGrgVategoriesVCTests.swift
//  RbGrgTests
//
//  Created by Timur Piriev on 1/18/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import XCTest
@testable import RbGrg



class RbGrgCategoriesVCTests: XCTestCase {
    
    var categoriesVC: RGCategoriesViewController!
    
    override func setUp() {
        super.setUp()
        
        categoriesVC = RGCategoriesViewController.newInstance()
        
        for _ in 1...5 {
            let category: RGCategory = RGCategory.init(name: "handmade_dolls", title: "Handmade")
            categoriesVC.categories.append(category)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSetSearchText() {
        let search = UISearchBar.init()
        categoriesVC.searchBar = search
        categoriesVC.searchBar.text = "Test keyword"
        XCTAssert(categoriesVC.searchBar.text == "Test keyword")
    }
    
    func testElementsForPicker() {
        for item in categoriesVC.categories {
            XCTAssert(item.name == "handmade_dolls", "Category name was modified")
            XCTAssert(item.title == "Handmade", "Title name was modified")
        }
    }
    
}
