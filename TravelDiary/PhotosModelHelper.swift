//
//  PhotosModel.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 12/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PhotosModelHelper {
    
    // Core Data managed context
    var managedContext : NSManagedObjectContext?
    
    func getPhotosPerTrip() -> [[Photo]] {
        
        let allPhotos: [Photo] = self.getAllPhotos()
        
        var result: [[Photo]] = [[]]
        
        NSLog("Get photos from core data sorted per trip")
        
        result = allPhotos.groupBy { $0.0.trip?.title == $0.1.trip?.title }
        
        //        allPhotos.categorise({ $0.trip?.title })
        
        return result
    }
    
    func getAllPhotos() -> [Photo]{
        
        NSLog("Get all photos from core data")
        var result: [Photo] = []
        // loadCoreDataImages fct with a completion block
        loadCoreDataImages { (fetchedImages:[Photo]?) -> Void in
            
            guard let fetchedImages = fetchedImages else {
                self.noImagesFound()
                return
            }
            
            result = fetchedImages
            
            NSLog("number of photos:%d", result.count)
        }
        
        return result
    }
    
    func loadCoreDataImages(fetched:(fetchedImages:[Photo]?) -> Void) {
        
        NSLog("loadCoreDataImages extension")
        
        guard let moc = managedContext else {
            NSLog("no managed context")
            return
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        
        do {
            let results = try moc.executeFetchRequest(fetchRequest)
            let imageData = results as? [Photo]
            NSLog("imageData %d", (imageData?.count)!)
            //Execute function in parameter
            fetched(fetchedImages: imageData)
        } catch {
            noImagesFound()
            return
        }
    }
    
    func noImagesFound() {
        
        NSLog("No image found")
    }
    
    func coreDataSetup() {
        managedContext = AppDelegate().managedObjectContext
    }
}

extension CollectionType {
    
    public typealias ItemType = Self.Generator.Element
    public typealias Grouper = (ItemType, ItemType) -> Bool
    
    public func groupBy(grouper: Grouper) -> [[ItemType]] {
        var result : Array<Array<ItemType>> = []
        
        var previousItem: ItemType?
        var group = [ItemType]()
        
        for item in self {
            defer {previousItem = item}
            guard let previous = previousItem else {
                group.append(item)
                continue
            }
            if grouper(previous, item) {
                // Item in the same group
                group.append(item)
            } else {
                // New group
                result.append(group)
                group = [ItemType]()
                group.append(item)
            }
        }
        
        result.append(group)
        
        return result
    }
}