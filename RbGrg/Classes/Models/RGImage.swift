//
//  RGImage.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/15/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import Foundation
import UIKit

class RGImage {
    
    var fullImage: Data? = nil
    var thumbnailImage: Data? = nil
    var urlThumbnail: String? = nil
    var urlFull: String? = nil
    var height: CGFloat
    var width: CGFloat
    
    init() {
        self.urlThumbnail = nil
        self.urlFull = nil
        self.height = 1.0
        self.width = 1.0
    }
    
    init(thumbnailUrl: String, fullUrl: String, width: Int, height: Int) {
        self.urlThumbnail = thumbnailUrl
        self.urlFull = fullUrl
        self.height = CGFloat.init(height)
        self.width = CGFloat.init(width)
    }
    

    
}
