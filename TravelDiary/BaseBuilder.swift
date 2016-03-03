//
//  BaseBuilder.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import CoreData;

class BaseBuilder {
    
    var managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext){
        self.managedObjectContext = managedObjectContext
    }
}