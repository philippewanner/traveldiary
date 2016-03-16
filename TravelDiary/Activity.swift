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
    
    private static var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter
    }
    
    var dateAsString: String? {
        guard let date = date else {
            return nil
        }
        return Activity.dateFormatter.stringFromDate(date)
    }

    func addLocation(newLocation:Location){
        self.location = newLocation
    }
    
    func removeLocation(){
        self.location = nil
    }
    
    func addPhoto(photo:Photo){
        let photos = self.mutableSetValueForKey("photos")
        photos.addObject(photo)
    }

}
