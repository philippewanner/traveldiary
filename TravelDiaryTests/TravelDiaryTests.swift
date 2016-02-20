//
//  TravelDiaryTests.swift
//  TravelDiaryTests
//
//  Created by Andreas Heubeck on 08/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import XCTest
import CoreData

@testable import TravelDiary

class TravelDiaryTests: XCTestCase {
    
    let managedObjectContext = CoreDataHelper.setUpInMemoryManagedObjectContext()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func saveTrip() {
        let newTrip = Trip(managedObjectContext: managedObjectContext)
        newTrip.title = "Tokyo to Nagano"
        newTrip.startDate = NSDate()
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        let request = NSFetchRequest(entityName: Trip.entityName())
        request.returnsObjectsAsFaults = false;
        //Something like sql
        request.predicate = NSPredicate(format:"title CONTAINS 'Tokyo to Nagano' ")
        var results:NSArray
        do{
            results = try managedObjectContext.executeFetchRequest(request)
            XCTAssertEqual(results.count,1)
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func saveActivity(){
        let newTrip = Trip(managedObjectContext: managedObjectContext)
        newTrip.title = "America del Sur"
        newTrip.startDate = NSDate()
        
        let newActivity = Activity(managedObjectContext: managedObjectContext)
        newActivity.descr = "Machu Picchu"
        newActivity.trip = newTrip
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        let request = NSFetchRequest(entityName: Activity.entityName())
        request.returnsObjectsAsFaults = false;
        //Something like sql
        request.predicate = NSPredicate(format:"descr CONTAINS 'Machu Picchu' ")
        var results:NSArray
        
        do{
            results = try managedObjectContext.executeFetchRequest(request)
            XCTAssertEqual(results.count,1)
            let fetchedActivity = results[0] as! Activity
            XCTAssertEqual(fetchedActivity.descr, "Machu Picchu")
            XCTAssertNotNil(fetchedActivity.trip)
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
}
