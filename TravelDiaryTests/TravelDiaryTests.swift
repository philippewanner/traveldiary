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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let managedObjectContext = CoreDataHelper.setUpInMemoryManagedObjectContext()
        let newTrip = Trip(managedObjectContext: managedObjectContext)
        //Not really sexy with string to search for membervariables...
        newTrip.setValue("Tokyo to Nagano", forKey: "title")
        newTrip.setValue(NSDate(), forKey: "startDate")
        
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
