//
//  TripEditViewController.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class TripEditViewController : UIViewController, UINavigationControllerDelegate{
    
    @IBOutlet weak var tripTitle: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet var navItem: UINavigationItem!
    
    private struct Constants{
        static let editTripTitle = "Edit Trip"
        static let newTripTitle = "New Trip"
        static let saveTripSegue = "saveTripUnwindSegue"
        static let cancelTripSegue = "cancelEditTripUnwindSegue"
    }
    
    private let dateFormatter = NSDateFormatter()
    var currentTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.locale = NSLocale.currentLocale()
        self.setKnownData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.saveTripSegue {
            NSLog("prepare for segue '\(Constants.saveTripSegue)'")
            if isNotNullOrEmpty(tripTitle.text) {
                prepareTripDataToSave()
            }
        }else if segue.identifier == Constants.cancelTripSegue {
            NSLog("prepare for segue '\(Constants.cancelTripSegue)'")
        }
    }
    
    private func prepareTripDataToSave(){
        if self.currentTrip == nil {
            self.currentTrip = Trip(managedObjectContext: self.managedObjectContext)
            NSLog("added new trip: '\(tripTitle.text!)'")
        }else{
            NSLog("edited trip: '\(tripTitle.text!)'")
        }
        self.currentTrip?.title = tripTitle.text
        self.currentTrip?.startDate = startDate.date
        self.currentTrip?.endDate = endDate.date
    }
    
    private func isNotNullOrEmpty(aString: NSString?) -> Bool{
        if let currentSting = aString {
            if currentSting.trim() != "" {
                return true
            }
        }
        NSLog("no trip title set!")
        return false
    }
    
    private func setKnownData(){
        NSLog("setting known trip data")
        if self.currentTrip == nil {
            self.navItem.title = Constants.newTripTitle
        }else{
            self.navItem.title = Constants.editTripTitle
            self.dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            self.tripTitle.text = currentTrip?.title
            if let startDate = currentTrip?.startDate {
                self.startDate.date = startDate
            }
            if let endDate = currentTrip?.endDate{
                self.endDate.date = endDate
            }
        }
    }
}