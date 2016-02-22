//
//  Location+CoreDataProperties.swift
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

extension Location {

    @NSManaged var address: String?
    @NSManaged var countryCode: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var inActivity: NSManagedObject?
    @NSManaged var photos: NSSet?

}
