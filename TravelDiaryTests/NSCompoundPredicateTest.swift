//
//  NSCompoundPredicateTest.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 13/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import XCTest
import CoreData
import Foundation

@testable import TravelDiary

class NSCompoundPredicateTest: XCTestCase {
    
    let managedObjectContext = CoreDataHelper.setUpInMemoryManagedObjectContext()

    override func setUp() {
        super.setUp()
        ExampleTripDataBuilder(tripTitle: "An Example Trip", managedObjectContext: self.managedObjectContext).buildAndSaveIfNotExists()
        AustraliaTripDataLoader(tripTitle: "Australia", managedObjectContext: self.managedObjectContext).buildAndSaveIfNotExists()
        SouthAmericaTripLoader(tripTitle: "America del Sur", managedObjectContext: self.managedObjectContext).buildAndSaveIfNotExists()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let request = NSFetchRequest(entityName: Trip.entityName())
        request.returnsObjectsAsFaults = false;
        //Something like sql
        NSCompoundPredicate compound = NSCompoundPredicate(type: .OrPredicateType, subpredicates: [
            NSPredicate(format: <#T##String#>, argumentArray: <#T##[AnyObject]?#>))
            ]))
        request.predicate = NSPredicate(format:"title CONTAINS 'Tokyo to Nagano' ")
        var results:NSArray
        do{
            results = try managedObjectContext.executeFetchRequest(request)
            XCTAssertEqual(results.count,1)
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }

}
