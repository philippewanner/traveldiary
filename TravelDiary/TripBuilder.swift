//
//  ExampleDataCreator.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData;

class TripBuilder: BaseBuilder{
    
    private var startDate: NSDate = NSDate()
    private var endDate: NSDate = NSDate()
    private var title: String?
    private var activities: NSMutableSet?
    
    func build() -> Trip {
        let trip = Trip(managedObjectContext: self.managedObjectContext)
        trip.startDate = self.startDate
        trip.endDate = self.endDate
        trip.title = self.title
        return trip
    }
    
    func with(title title: String) -> TripBuilder {
        self.title = title
        return self
    }
    
    func with(endDate endDate: NSDate) -> TripBuilder {
        self.endDate = endDate
        return self
    }
    
    func with(startDate startDate: NSDate) -> TripBuilder {
        self.startDate = startDate
        return self
    }
    
    func with(activities activities: NSMutableSet) -> TripBuilder {
        self.activities = activities
        return self
    }
}