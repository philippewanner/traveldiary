//
//  Photo+CoreDataProperties.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 14/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var createDate: NSDate?
    @NSManaged var imageData: NSData?
    @NSManaged var title: String?
    @NSManaged var thumbnailData: NSData?
    @NSManaged var inActivity: Activity?
    @NSManaged var location: Location?
    @NSManaged var trip: Trip?

}
