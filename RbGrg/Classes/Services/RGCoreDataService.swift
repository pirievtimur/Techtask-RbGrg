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
    
    func storeItem(item: RGItem) -> Bool{
        
        if (itemWithId(id: item.id)) {
            print("Already is store")
            return false
        } else {
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "EtsyItem", in: context)
            
            let newItem = NSManagedObject(entity: entity!, insertInto: context)
            
            newItem.setValue(item.title, forKey: "itemTitle")
            newItem.setValue(item.id, forKey: "itemId")
            newItem.setValue(item.price, forKey: "itemPrice")
            newItem.setValue(item.currencyCode, forKey: "itemCurrency")
            newItem.setValue(item.itemDescription, forKey: "itemDescription")
            newItem.setValue(item.images.fullImage, forKey: "itemFullImage")
            newItem.setValue(item.images.thumbnailImage, forKey: "itemThumbnail")
            newItem.setValue(item.images.urlFull, forKey: "itemUrlFull")
            newItem.setValue(item.images.urlThumbnail, forKey: "itemUrlThumbnail")
            newItem.setValue(item.images.width, forKey: "itemImageWidth")
            newItem.setValue(item.images.height, forKey: "itemImageHeight")
            
            do {
                try context.save()
                return true
            } catch let error as NSError  {
                print("Error \(error.localizedDescription)")
                return false
            }
        }
    }
   
    
    func fetchItem(id: Int) -> RGItem {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EtsyItem")
        fetchRequest.predicate = NSPredicate.init(format: "itemId == \(id)", argumentArray: nil)
        
        let item = RGItem()
        
        do {
            let results = try getContext().fetch(fetchRequest)
            
            let fetchedObject = results.first as! NSManagedObject
            
            let item = convertManagedObject(object: fetchedObject)
                
            return item
        } catch let error as NSError {
            print(error.localizedDescription)
            return item
        }
    }
    
    func fetchItems() -> [RGItem] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EtsyItem")
        
        var items: [RGItem] = []
        
        do {
            let results = try getContext().fetch(fetchRequest)
            
                for item in results as! [NSManagedObject] {
                    items.append(convertManagedObject(object: item))
                }
            
                return items
            
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return items
        }
    }
    
    func deleteItem(item: RGItem) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EtsyItem")
        
        fetchRequest.predicate = NSPredicate.init(format: "itemId == \(item.id)", argumentArray: nil)
        
        let context = getContext()
        
        do {
            let result = try context.fetch(fetchRequest)
            for object in result{
                context.delete(object as! NSManagedObject)
            }
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
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
        newItem.images.urlThumbnail = object.value(forKey:"itemUrlThumbnail") as? String
        newItem.images.width = object.value(forKey:"itemImageWidth") as! CGFloat
        newItem.images.height = object.value(forKey:"itemImageHeight") as! CGFloat
        newItem.images.thumbnailImage = object.value(forKey:"itemThumbnail") as? Data
        newItem.images.fullImage = object.value(forKey:"itemFullImage") as? Data
        
        return newItem
    }
}
