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


extension PhotosController {
    
    /**
     Load all images saved by Core Data
     
     - parameter fetched: Completion Block for the background fetch.
     */
    func loadCoreDataImages(fetched:(fetchedImages:[Photo]?) -> Void) {
        
        NSLog("loadCoreDataImages extension")
        
        guard let moc = self.managedContext else {
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
    
    /**
     Display Alert when loadImages had no results
     */
    func noImagesFound() {
        
        let alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        let alertVC = UIAlertController(title: "No Images Found", message: "There were no images saved in Core Data", preferredStyle: .Alert)
        
        alertVC.addAction(alertAction)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    /**
     Start Core Data managed context on the correct queue
     */
    func coreDataSetup() {
        self.managedContext = AppDelegate().managedObjectContext
    }
}