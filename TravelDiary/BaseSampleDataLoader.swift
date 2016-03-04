//
//  BaseSampleDataLoader.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 04/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import CoreData;

class BaseSampleDataLoader {
    
    var context: NSManagedObjectContext
    init(managedObjectContext context: NSManagedObjectContext){
        self.context = context
    }
}