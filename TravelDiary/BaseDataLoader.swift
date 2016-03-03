//
//  BaseDataBuilder.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import CoreData;

class BaseDataLoader {
    
    var managedObjectContext: NSManagedObjectContext
    var activityBuilder: ActivityBuilder
    var tripBuilder: TripBuilder
    var locationBuilder: LocationBuilder
    var photoBuilder: PhotoBuilder
    
    init(managedObjectContext: NSManagedObjectContext){
        self.managedObjectContext = managedObjectContext
        activityBuilder = ActivityBuilder(managedObjectContext: managedObjectContext)
        tripBuilder = TripBuilder(managedObjectContext: managedObjectContext)
        photoBuilder = PhotoBuilder(managedObjectContext: managedObjectContext)
        locationBuilder = LocationBuilder(managedObjectContext: managedObjectContext)
    }
    
    func isSampleTripDataAlreadyLoaded(sampleTripTitle tripTitle: String) -> Bool{
        var results:NSArray
        do{
            results = try managedObjectContext.executeFetchRequest(createRequest(tripTitle))
            if (results.count > 0){
                print("sample data already loaded")
                return true
            } else {
                print("sample data not yet loaded")
                return false
            }
        }catch let error as NSError  {
            print("Fetch error: \(error), \(error.userInfo)")
        }
        return true
    }
    
    private func createRequest(tripTitleToMatch: String) -> NSFetchRequest{
        let request = NSFetchRequest(entityName: Trip.entityName())
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format:"title MATCHES '" + tripTitleToMatch + "' ")
        return request
    }
    
    
    func saveData() {
        if self.managedObjectContext.hasChanges {
            do {
                try self.managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}