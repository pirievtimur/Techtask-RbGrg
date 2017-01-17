//
//  RGSearchResultsCollectionViewController.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/13/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import UIKit
import SDWebImage

class RGSearchResultsCollectionViewController: RGCollectionViewController {

    var category: RGCategory!
    var keyword: String!
    let searchService: RGSearchHTTPService = RGSearchHTTPService()
    
    var pagination: PaginationStatus = .off
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.title
        
        loadData()
    }
    
    override func loadData() {
        refreshControl.beginRefreshing()
        searchService.loadData(category: (category?.name)!, keyword: keyword, completionBlock: { [weak self] (results) in
            self?.results = results
            self?.collectionView?.reloadData()
            self?.refreshControl.endRefreshing()
        }) { [weak self] (error) in
            self?.refreshControl.endRefreshing()
            print(error)
        }
    }
    
    override func loadNextData() {
        searchService.loadNextData(category: (category?.name)!, keyword: keyword, completionBlock: { [weak self] (results) in
            self?.results.append(contentsOf: results)
            self?.collectionView?.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    // MARK: - Collection view methods
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: RGCollectionViewCell.reuseIdentifier, for: indexPath) as! RGCollectionViewCell
        
        let item = results[indexPath.row]
        
        if let thumbnailUrl = item.images.urlThumbnail {
            let url = URL.init(string: thumbnailUrl)
            cell.image.sd_setImage(with: url, placeholderImage: UIImage.init(named: "item_placeholder"), options: .lowPriority, completed: { (image, error, cache, url) in
                if let itemImage = image {
                    item.images.thumbnailImage = UIImagePNGRepresentation(itemImage)!
                }
            })
        } else {
            let image = UIImage.init(named: "item_placeholder")!
            item.images.thumbnailImage = UIImagePNGRepresentation(image)
            cell.image.image = image
        }
        

        cell.title.text = item.title
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.results.count - 1) { loadNextData() }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = RGDetailsViewController.newInstance()
        detailsVC.item = results[indexPath.row]
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
