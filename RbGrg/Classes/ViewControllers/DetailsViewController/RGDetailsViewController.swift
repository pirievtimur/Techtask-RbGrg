//
//  RGDetailsViewController.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/16/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import UIKit
import SDWebImage
import EZAlertController

enum StoreStatus {
    case stored
    case notStored
}

class RGDetailsViewController: UIViewController {
    
    let storageManager: RGCoreDataService = RGCoreDataService()
    
    var item: RGItem = RGItem()
    
    var storageFlag: StoreStatus = .notStored
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var itemImageHeightConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        displayData()
    }
    
    func displayData() {
        
        if let title = item.title {
            self.title = title
            itemTitle.text = title
        }
        
        let constantValue = calculateHeight(view: self.view, originalWidth: self.item.images.width, originalHeight: self.item.images.height)
        
        self.itemImageHeightConstraint.constant = constantValue
        
        if let imageData = item.images.fullImage {
            self.itemImage.image = UIImage.init(data: imageData)
        } else if let urlString = item.images.urlFull {
            self.itemImage.sd_setImage(with: URL.init(string: urlString), completed: { [unowned self] (image, error, cache, url) in

                self.item.images.fullImage = UIImagePNGRepresentation(image!)
            })
        } else {
            let image = UIImage.init(named: "item_placeholder")!
            self.item.images.fullImage = UIImagePNGRepresentation(image)
            self.itemImage.image = image
        }

        if let price = item.price, let currency = item.currencyCode {
            itemPrice.text = "Price: \(price) \(currency)"
        }
        
        if let description = item.itemDescription {
            itemDescription.text = description
        }
        
        if (storageManager.itemWithId(id: item.id)) {
            saveButton.setTitle("Delete", for: .normal)
            storageFlag = .stored
        } else {
            storageFlag = .notStored
        }
        
        storageFlag = storageManager.itemWithId(id: item.id) == true ? .stored : .notStored
        updateSaveButton()
        
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        switch storageFlag {
        case .stored:
            storageManager.deleteItem(item: item)
            self.navigationController?.popViewController(animated: true)
        case .notStored:
            let stored = storageManager.storeItem(item: item)
            if (stored) {
                self.storageFlag = .stored
                self.showAlert("Item is saved")
                self.displayData()
            }
        }
    }
    
    func updateSaveButton() {
        switch storageFlag {
        case .stored:
            saveButton.backgroundColor = UIColor.red
            saveButton.setTitle("Delete", for: .normal)
        case .notStored:
            saveButton.backgroundColor = UIColor.blue
            saveButton.setTitle("Save", for: .normal)
        }
    }
    
    func showAlert(_ title: String) {
        EZAlertController.alert(title)
    }
}


