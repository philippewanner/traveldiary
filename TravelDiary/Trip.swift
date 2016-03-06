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
    
    private static var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter
    }
    
    var tripPeriod: String? {
        guard let startDate = startDate, let endDate = endDate else {
            return nil
        }
        return Trip.dateFormatter.stringFromDate(startDate) + " - " + Trip.dateFormatter.stringFromDate(endDate)
    }

    func addActitiesObject(activity:Activity){
        let activities = self.mutableSetValueForKey("activities")
        activities.addObject(activity)
    }
    
    func removeActivity(activity:Activity){
        let activities = self.mutableSetValueForKey("activities")
        activities.removeObject(activity)
    }
    
}
