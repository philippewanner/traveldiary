//
//  NSDate+addingDaysFunction.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 14/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation

extension NSDate {
    
    func addDays(days:Int) -> NSDate{
        let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: days,
            toDate: self,
            options: NSCalendarOptions(rawValue: 0))
        
        return newDate!
    }
}
