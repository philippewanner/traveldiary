//
//  Activity+CoreDataProperties.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Activity {

    @NSManaged var date: NSDate?
    @NSManaged var descr: String?
    @NSManaged var type: NSDecimalNumber?
    @NSManaged var title: String?
    @NSManaged var location: Location?
    @NSManaged var photos: NSSet?
    @NSManaged var trip: Trip?

}
