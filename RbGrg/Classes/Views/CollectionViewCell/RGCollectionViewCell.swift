//
//  RGCollectionViewCell.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/13/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import UIKit

class RGCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier: String = "RGCollectionViewCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image.image = nil
    }
}
