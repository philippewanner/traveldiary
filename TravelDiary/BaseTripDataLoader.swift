//
//  BaseTripDataLoader.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import CoreData;

class BaseTripDataLoader {
    
    var managedObjectContext: NSManagedObjectContext
    var activityBuilder: ActivityBuilder
    var tripBuilder: TripBuilder
    var locationBuilder: LocationBuilder
    var photoBuilder: PhotoBuilder
    var tripTitle: String
    var trip: Trip!
    var activities = NSMutableSet()
    var currentLocation: Location?
    
    init(tripTitle title: String, managedObjectContext: NSManagedObjectContext){
        self.tripTitle = title
        self.managedObjectContext = managedObjectContext
        activityBuilder = ActivityBuilder(managedObjectContext: managedObjectContext)
        tripBuilder = TripBuilder(managedObjectContext: managedObjectContext)
        photoBuilder = PhotoBuilder(managedObjectContext: managedObjectContext)
        locationBuilder = LocationBuilder(managedObjectContext: managedObjectContext)
    }
    
    func createWholeTripData(){
        // Delegate function, which needs to be overriden!
    }
    
    func buildAndSaveIfNotExists(){
        if(isSampleTripDataAlreadyLoaded()) {return}
        self.trip = tripBuilder.with(title: tripTitle).build()
        self.createWholeTripData()
        trip.activities = self.activities
        self.saveData()
    }
    
    private func isSampleTripDataAlreadyLoaded() -> Bool{
        var results:NSArray
        do{
            results = try managedObjectContext.executeFetchRequest(createRequest(tripTitle))
            if (results.count > 0){
                NSLog("sample data already loaded")
                return true
            } else {
                NSLog("sample data not yet loaded")
                return false
            }
        }catch let error as NSError  {
            NSLog("Fetch error: \(error), \(error.userInfo)")
        }
        return true
    }
    
    private func createRequest(tripTitleToMatch: String) -> NSFetchRequest{
        let request = NSFetchRequest(entityName: Trip.entityName())
        request.returnsObjectsAsFaults = false;
        request.predicate = NSPredicate(format:"title MATCHES '" + tripTitleToMatch + "' ")
        return request
    }
    
    
    private func saveData() {
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