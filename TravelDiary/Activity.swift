//
//  Activity.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 15/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreData


class Activity: NSManagedObject {

    func addLocation(newLocation:Location){
        self.location = newLocation
    }
    
    func removeLocation(){
        self.location = nil
    }
    
    func addPhoto(photo:Photo){
        let activities = self.mutableSetValueForKey("photos")
        activities.addObject(photo)
    }

}
