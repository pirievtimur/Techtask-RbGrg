//
//  RGSavedItemsCollectionViewController.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/11/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import UIKit

class RGSavedItemsCollectionViewController: RGCollectionViewController {
    
    let storageManager: RGCoreDataService = RGCoreDataService()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "Saved items"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    override func loadData() {
        results = []
        refreshControl.beginRefreshing()
        results = storageManager.fetchItems()
        self.collectionView?.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - Collection view methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return results.count }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: RGCollectionViewCell.reuseIdentifier, for: indexPath) as! RGCollectionViewCell
        
        let item = results[indexPath.row]
        
        if let imageData = item.images.thumbnailImage {
            cell.image.image = UIImage.init(data: imageData)
        } else if let imageData = item.images.fullImage {
            cell.image.image = UIImage.init(data: imageData)
        } else {
            cell.image.image = UIImage.init(named: "item_placeholder")
        }
        
        if let title = item.title {
            cell.title.text = title
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = RGDetailsViewController.newInstance()
        detailsVC.item = results[indexPath.row]
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
