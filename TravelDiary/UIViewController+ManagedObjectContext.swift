//
//  UIViewController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 20/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    /*!
        Returns the managedObjectContext store on the appDelegate.
    */
    var managedObjectContext:NSManagedObjectContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.coreDataController.managedObjectContext
    }
    
    /*!
        saves the managedObjectContext
    */
    func saveContext(){
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
