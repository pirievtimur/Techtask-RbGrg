//
//  RGHTTPService.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/13/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import Foundation

enum HTTPServiceState {
    case busy
    case free
}

class RGHTTPService {
    
    func convertData(data: Data) -> [String : AnyObject] {
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
    }
}
