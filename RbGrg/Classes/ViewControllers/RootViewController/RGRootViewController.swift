//
//  RGRootViewController.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/12/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import UIKit

class RGRootViewController : UIViewController {
    
    @IBOutlet var rootView: RGRootView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers()
    }
    
    func setViewControllers() {
        
        let searchVC = UINavigationController.init(rootViewController: RGCategoriesViewController.newInstance())
        searchVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .search, tag: 0)
        
        let savedItemsVC = UINavigationController.init(rootViewController: RGSavedItemsCollectionViewController.newInstance())
        savedItemsVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 1)
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [searchVC, savedItemsVC]
        addChildViewController(tabBarController, toView: rootView.container)
    }
}
