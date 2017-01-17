//
//  RGCategoriesViewController.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/11/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import UIKit
import EZAlertController

class RGCategoriesViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var categoryPickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchButtonHeightConstraint: UIButton!
    
    var categories: [RGCategory] = []
    
    let categoriesHTTPService: RGCategoriesHTTPService = RGCategoriesHTTPService()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "Categories"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategories()
        
        subscribeKeyboardNotifications()
        
        self.searchBar.delegate = self
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    deinit {
        unsubscribeKeyboardNotifications()
    }
    
    func getCategories() {
        categoriesHTTPService.loadData(completionBlock: { [unowned self] (categories) in
            self.categories = categories
            self.categoryPicker.reloadAllComponents()
            self.categoryPickerHeightConstraint.constant = 150
        }) { (error) in
            print(error)
        }
    }
    
    @IBAction func onClickSearchButton(_ sender: Any) {
        if ((self.searchBar.text?.isEmpty)! || self.searchBar.text == nil || self.categories.count == 0) {
            EZAlertController.alert("Enter keyword")
            return
        }
        let searchResultsVC = RGSearchResultsCollectionViewController.newInstance()
        searchResultsVC.keyword = (self.searchBar.text?.lowercased())!
        searchResultsVC.category = self.categories[categoryPicker.selectedRow(inComponent: 0)]
        self.navigationController?.pushViewController(searchResultsVC, animated: true)
    }
    
    // MARK: - UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return categories.count }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return categories[row].title }
    
    // MARK: - Searchbar delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    //MARK: - Keyboard methods
    
    func subscribeKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillAppear(notification: NSNotification)
    {
        let info = notification.userInfo
        let kbFrame = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let kbAnimationTime = (info?[UIKeyboardAnimationDurationUserInfoKey]) as! Double
        searchButtonHeightConstraint.constant = 60
        searchButtonBottomConstraint.constant = kbFrame.height
        UIView.animate(withDuration: kbAnimationTime) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        let info = notification.userInfo
        let kbAnimationTime = (info?[UIKeyboardAnimationDurationUserInfoKey]) as! Double
        searchButtonHeightConstraint.constant = 0
        searchButtonBottomConstraint.constant = 0
        UIView.animate(withDuration: kbAnimationTime) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
}
