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
//        let entity = NSEntityDescription.insertNewObjectForEntityForName("Activity", inManagedObjectContext: managedObjectContext)
        let trip = Trip(managedContext)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
