//
//  LoadingPhotos.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension PhotosAllController {
    
    /**
     Load all images saved by Core Data
     
     - parameter fetched: Completion Block for the background fetch.
     */
    func loadCoreDataImages(fetched:(fetchedThumbnails:[Photo]?) -> Void) {
        
        NSLog("loadCoreDataImages extension")
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.relationshipKeyPathsForPrefetching = ["thumbnailBlob"]
        
        do {
            let results = try managedObjectContext.executeFetchRequest(fetchRequest)
            let photos = results as? [Photo]
            NSLog("%d photos found", (photos?.count)!)
            //Execute function in parameter
            fetched(fetchedThumbnails: photos)
        } catch {
            noImagesFound()
            return
        }
    }

    func noImagesFound() {
        NSLog("No photo found")
    }
}