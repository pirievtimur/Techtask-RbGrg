//
//  RGSearchHTTPService.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/13/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import Foundation
import Alamofire

enum PaginationStatus {
    case on
    case off
}

class RGSearchHTTPService : RGHTTPService {

    var pagination: PaginationStatus = .off
    
    var limit: Int = 20
    var offset: Int = 0
    
    func loadData(category: String, keyword: String, completionBlock: @escaping ([RGItem]) -> (), failureBlock: @escaping (Any) -> ()) {
        
        pagination = .off
        
        self.offset = 0
        
        Alamofire.request(Endpoints.search, parameters: ["api_key":Globals.apiKey, "keyword":keyword, "category":category, "limit": limit, "offset":offset]).validate().responseJSON { [weak self] response in
            DispatchQueue.global().async(execute: {
                switch response.result{
                case .success:
                    let JSONdict = self?.convertData(data: response.data!)
                    let items = self?.parseToModel(json: JSONdict!)
                    let group = DispatchGroup()
                    for item in items! {
                        group.enter()
                        
                        self?.loadImageData(item: item, completionBlock: { (image) in
                            item.images = image
                            group.leave()
                        }, failureBlock: { (error) in
                            group.leave()
                            print(error)
                        })
                    }
                    group.notify(queue: .main, execute: {
                        DispatchQueue.main.async(execute: {
                            self?.pagination = .off
                            completionBlock(items!)
                        })
                    })
                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        self?.pagination = .off
                        failureBlock(error)
                    })
                }
            })
        }
    }
    
    func loadNextData(category: String, keyword: String, completionBlock: @escaping ([RGItem]) -> (), failureBlock: @escaping (Any) -> ()) {
        
        
        if (pagination == .on) { return }
        
        self.offset += self.limit
        
        pagination = .on
        
        Alamofire.request(Endpoints.search, parameters: ["api_key":Globals.apiKey, "keyword":keyword, "category":category, "limit": limit, "offset":offset]).validate().responseJSON { [weak self] response in
            DispatchQueue.global().async(execute: { 
                switch response.result{
                case .success:
                    let JSONdict = self?.convertData(data: response.data!)
                    let items = self?.parseToModel(json: JSONdict!)
                    let group = DispatchGroup()
                    for item in items! {
                        group.enter()
                        
                        self?.loadImageData(item: item, completionBlock: { (image) in
                            item.images = image
                            group.leave()
                        }, failureBlock: { (error) in
                            group.leave()
                            print(error)
                        })
                    }
                    group.notify(queue: .main, execute: {
                        DispatchQueue.main.async(execute: { 
                            self?.pagination = .off
                            completionBlock(items!)
                        })
                    })
                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        self?.pagination = .off
                        failureBlock(error)
                    })
                }
            })
        }
    }
    
    func loadImageData(item: RGItem, completionBlock: @escaping (RGImage) -> (), failureBlock: @escaping (Any) -> ()) {
        
        var url: String = ""
        
        if let id = String.init("\(item.id)") {
            url = Endpoints.images.appending(id).appending("/images")
        }
        
        
        Alamofire.request(url, parameters: ["api_key":Globals.apiKey]).validate().responseJSON { [weak self] response in
            switch response.result{
            case .success:
                let JSONdict = self?.convertData(data: response.data!)
                let image = self?.parseImageModel(json: JSONdict!)
                if (image != nil) {
                    completionBlock(image!)
                }
            case .failure(let error):
                failureBlock(error)
            }
        }
    }
    
    private func parseToModel(json: [String : AnyObject]) -> [RGItem] {
        var results: [RGItem] = []
        if let data = json["results"] as? [AnyObject] {
            for item in data {
                let resultItem = RGItem()
                resultItem.title = item["title"] as? String
                resultItem.id = item["listing_id"] as! Int
                resultItem.itemDescription = item["description"] as? String
                resultItem.price = item["price"] as? String
                resultItem.currencyCode = item["currency_code"] as? String
                results.append(resultItem)
            }
        }
        return results
    }
    
    private func parseImageModel(json: [String : AnyObject]) -> RGImage {
        if let data = json["results"] as? [AnyObject] {
            let item = data.first
            
            let urlThumbnail = item?["url_570xN"] as? String
            let urlFull = item?["url_fullxfull"] as? String
            let height = item?["full_height"] as? Int
            let width = item?["full_width"] as? Int
            
            
            return RGImage.init(thumbnailUrl: urlThumbnail!, fullUrl: urlFull!, width: width!, height: height!)
        }
        return RGImage()
    }

}

