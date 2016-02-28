//
//  Trip.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 15/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreData


class Trip: NSManagedObject {

    func addActitiesObject(activity:Activity){
        let activities = self.mutableSetValueForKey("activities")
        activities.addObject(activity)
    }
    
    func removeActivity(activity:Activity){
        let activities = self.mutableSetValueForKey("activities")
        activities.removeObject(activity)
    }
    
}
