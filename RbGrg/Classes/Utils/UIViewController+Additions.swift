//
//  UIViewController+Additions.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/11/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import SnapKit
import Foundation

extension UIViewController {
    
    // MARK: - Public
    
    class func newInstance() -> Self {
        return newInstance(self)
    }
    
    func addChildViewController(_ childController: UIViewController, toView view: UIView) {
        willMove(toParentViewController: self)
        addChildViewController(childController)
        view.addSubview(childController.view)
        childController.didMove(toParentViewController: self)
        
        childController.view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    func removeViewControllerFromSuperView() {
        willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        removeFromParentViewController()
    }
    
    // MARK: - Private
    
    fileprivate class func newInstance<T>(_ type : T.Type) -> T {
        let storyboardName = self.storyboardName()
        let className = self.className()
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let newInstance = storyboard.instantiateViewController(withIdentifier: className) as! T
        
        return newInstance
    }
    
    fileprivate class func storyboardName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    fileprivate class func className() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
