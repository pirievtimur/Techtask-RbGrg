//
//  Calculations.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/17/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Helper functions

func calculateHeight(view: UIView, originalWidth: CGFloat, originalHeight: CGFloat) -> CGFloat {
    let screenWidth = view.frame.width
    do {
        let aspectRatio = try originalHeight / originalWidth
        return screenWidth * aspectRatio
    } catch {
        return 1.0
    }
//    let aspectRatio = originalHeight / originalWidth
//    if (aspectRatio != nil ) {
//        return screenWidth * aspectRatio
//    } else {
//        return 1.0
//    }
    
}
