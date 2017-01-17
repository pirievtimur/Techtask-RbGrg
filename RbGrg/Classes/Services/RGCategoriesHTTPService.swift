//
//  RGCategoriesHTTPService.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/12/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import Foundation
import Alamofire

class RGCategoriesHTTPService : RGHTTPService {

    func loadData(completionBlock: @escaping ([RGCategory]) -> (), failureBlock: @escaping (Any) -> ()) {
        Alamofire.request(Endpoints.categories, parameters: ["api_key":Globals.apiKey]).validate().responseJSON { [unowned self] response in
            switch response.result{
            case .success:
                let JSONdict = self.convertData(data: response.data!)
                let categories = self.parseToModel(json: JSONdict)
                completionBlock(categories)
            case .failure(let error):
                failureBlock(error)
            }
        }
    }
    
    private func parseToModel(json: [String : AnyObject]) -> [RGCategory] {
        var categories: [RGCategory] = []
        if let data = json["results"] as? [AnyObject] {
            for item in data {
                
                let title = item["page_title"] as? String
                let name = item["name"] as? String
                
                let category = RGCategory.init(name: name!, title: title!)
                categories.append(category)
            }
        }
        return categories
    }
}

