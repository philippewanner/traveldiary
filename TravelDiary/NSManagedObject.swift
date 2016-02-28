//
//  NSManagedObjectExtension.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 16/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import CoreData

/* !
    Extension for NSManagedObject
*/
extension NSManagedObject {
    
    /*!
        Returns the name of the entity
    */
    public class func entityName() -> String {
        // NSStringFromClass is available in Swift 2.
        // If the data model is in a framework, then
        // the module name needs to be stripped off.
        //
        // Example:
        //   FooBar.Engine
        //   Engine
        let name = NSStringFromClass(self)
        return name.componentsSeparatedByString(".").last!
    }
    
    /*!
        Convinience initializer to avoid calling all the methods to create an entity
    */
    convenience init(managedObjectContext: NSManagedObjectContext) {
        let entityName = self.dynamicType.entityName()
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }
}
