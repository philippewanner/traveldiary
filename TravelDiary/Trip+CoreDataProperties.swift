//
//  Trip+CoreDataProperties.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 15/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var endDate: NSDate?
    @NSManaged var startDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var activities: NSSet?
    @NSManaged var pictures: NSSet?

}
