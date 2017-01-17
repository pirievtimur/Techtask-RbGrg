//
//  RGHTTPImageService.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/15/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage

class RGHTTPImageService : RGHTTPService {
    
    func loadImageData(item: RGItem, completionBlock: @escaping (RGImage) -> (), failureBlock: @escaping (Any) -> ()) {
        var url: String = ""
        
        if let id = String.init("\(item.id)") {
            url = Endpoints.images.appending(id).appending("/images")
        }
        
        
        Alamofire.request(url, parameters: ["api_key":Globals.apiKey]).validate().responseJSON { [unowned self] response in
            switch response.result{
            case .success:
                let JSONdict = self.convertData(data: response.data!)
                let image = self.parseToModel(json: JSONdict)
                completionBlock(image)
            case .failure(let error):
                failureBlock(error)
            }
        }
    }
    
    private func parseToModel(json: [String : AnyObject]) -> RGImage {
        let image: RGImage = RGImage()
        if let data = json["results"] as? [AnyObject] {
            let item = data.first
            
            image.urlThumbnail = item?["url_170x135"] as? String
            image.urlFull = item?["url_fullxfull"] as? String
            image.height = item?["full_height"] as? Int
            image.width = item?["full_width"] as? Int
            
            return image
        }
        return image
    }
}
