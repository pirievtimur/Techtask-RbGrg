//
//  RGCollectionViewController.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/13/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import UIKit

class RGCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var results: [RGItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.register(UINib.init(nibName: RGCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: RGCollectionViewCell.reuseIdentifier)
        
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView?.addSubview(refreshControl)
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return self.results.count }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - padding
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func loadData() {}
    
    func loadNextData() {}

}
