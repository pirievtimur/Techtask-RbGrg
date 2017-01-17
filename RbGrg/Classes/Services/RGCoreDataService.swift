//
//  RGCoreDataService.swift
//  RbGrg
//
//  Created by Timur Piriev on 1/16/17.
//  Copyright © 2017 Timur Piriev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class RGCoreDataService {
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func storeItem(item: RGItem, completionBlock: @escaping () -> (), failureBlock: @escaping (String) -> ()) {
        
        if (itemWithId(id: item.id)) {
            failureBlock("Already in store")
        } else {
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "EtsyItem", in: context)
            
            let newItem = NSManagedObject(entity: entity!, insertInto: context)
            
            newItem.setValue(item.title, forKey: "itemTitle")
            newItem.setValue(item.id, forKey: "itemId")
            newItem.setValue(item.price, forKey: "itemPrice")
            newItem.setValue(item.currencyCode, forKey: "itemCurrency")
            newItem.setValue(item.itemDescription, forKey: "itemDescription")
//            newItem.setValue(item.images.thumbnail, forKey: "itemThumbnail")
            newItem.setValue(item.images.fullImage, forKey: "itemFullImage")
//            newItem.setValue(item.images.url570, forKey: "itemUrl570")
            newItem.setValue(item.images.urlFull, forKey: "itemUrlFull")
            newItem.setValue(item.images.width, forKey: "itemImageWidth")
            newItem.setValue(item.images.height, forKey: "itemImageHeight")
            
            do {
                try context.save()
                print("Item saved")
                completionBlock()
            } catch let error as NSError  {
                print("Error \(error.localizedDescription)")
                failureBlock(error.localizedDescription)
            }
        }
    }
   
    
    func fetchItem(id: Int, completionBlock: @escaping (RGItem) -> (), failureBlock: @escaping (String) -> ()) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EtsyItem")
        fetchRequest.predicate = NSPredicate.init(format: "itemId == \(id)", argumentArray: nil)
        
        do {
            let results = try getContext().fetch(fetchRequest)
            
            let fetchedObject = results.first as! NSManagedObject
            
            let item = convertManagedObject(object: fetchedObject)
                
            completionBlock(item)
        } catch let error as NSError {
            failureBlock(error.localizedDescription)
        }
    }
    
    func fetchItems(completionBlock: @escaping ([RGItem]) -> (), failureBlock: @escaping (String) -> ()) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EtsyItem")
        
        var items: [RGItem] = []
        
        do {
            let results = try getContext().fetch(fetchRequest)
            
                for item in results as! [NSManagedObject] {
                    items.append(convertManagedObject(object: item))
                }
            
                completionBlock(items)
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            failureBlock(error.localizedDescription)
        }
    }
    
    func deleteItem(item: RGItem, completionBlock: @escaping () -> (), failureBlock: @escaping (String) -> ()) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EtsyItem")
        
        fetchRequest.predicate = NSPredicate.init(format: "itemId == \(item.id)", argumentArray: nil)
        
        let context = getContext()
        
        do {
            let result = try context.fetch(fetchRequest)
            for object in result{
                context.delete(object as! NSManagedObject)
            }
            try context.save()
            completionBlock()
        } catch let error as NSError {
            failureBlock(error.localizedDescription)
        }
    }
    
    func itemWithId(id: Int) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EtsyItem")
        fetchRequest.predicate = NSPredicate.init(format: "itemId == \(id)", argumentArray: nil)
        
        let context = getContext()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.count != 0 ? true : false
        } catch let error as NSError {
            print(error)
            return true
        }
    }
    
    func convertManagedObject(object: NSManagedObject) -> RGItem {
        let newItem = RGItem()
        
        newItem.id = object.value(forKey:"itemId") as! Int
        newItem.title = object.value(forKey:"itemTitle") as? String
        newItem.itemDescription = object.value(forKey:"itemDescription") as? String
        newItem.price = object.value(forKey:"itemPrice") as? String
        newItem.currencyCode = object.value(forKey:"itemCurrency") as? String
        newItem.images.urlFull = object.value(forKey:"itemUrlFull") as? String
        newItem.images.width = object.value(forKey:"itemImageWidth") as! CGFloat
        newItem.images.height = object.value(forKey:"itemImageHeight") as! CGFloat
        newItem.images.thumbnailImage = object.value(forKey:"itemThumbnail") as? Data
        newItem.images.fullImage = object.value(forKey:"itemFullImage") as? Data
        
        return newItem
    }
}
