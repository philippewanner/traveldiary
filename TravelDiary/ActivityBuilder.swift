//
//  ActivityBuilder.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
import UIKit
import CoreData;

class ActivityBuilder: BaseBuilder{
    
    private var description: String?
    private var date: NSDate = NSDate()
    
    func build() -> Activity{
        let activity = Activity(managedObjectContext: managedObjectContext)
        activity.descr = self.description
        activity.date = self.date
        return activity
    }
    
    func with(description descr: String) -> ActivityBuilder{
        self.description = descr
        return self
    }
    
    func with(date date: NSDate) -> ActivityBuilder{
        self.date = date
        return self
    }
}
