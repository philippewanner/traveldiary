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
    
    private let dateFormatter = NSDateFormatter()
    
    var selectedTrip: Trip?
    
    private struct Constants{
        static let localeIdentifier = "de_CH"
        static let editTripTitle = "Edit Trip"
        static let newTripTitle = "New Trip"
        static let saveTripSegue = "saveTripUnwindSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = NSLocale.currentLocale()
        setKnownData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.saveTripSegue {
            if isNotNullOrEmpty(tripTitle.text) {
                if self.selectedTrip == nil {
                    self.selectedTrip = Trip(managedObjectContext: self.managedObjectContext)
                    NSLog("added new trip: '\(tripTitle.text!)'")
                }else{
                    NSLog("edited trip: '\(tripTitle.text!)'")
                }
                selectedTrip?.title = tripTitle.text
                selectedTrip?.startDate = startDate.date
                selectedTrip?.endDate = endDate.date
            }
        }
    }
    
    private func isNotNullOrEmpty(aString: NSString?) -> Bool{
        if let currentSting = aString {
            if currentSting.trim() != "" {
                return true
            }
        }
        return false
    }
    
    private func setKnownData(){
        
        if selectedTrip != nil {
            navItem.title = Constants.editTripTitle
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            tripTitle.text = selectedTrip?.title
            startDate.date = (selectedTrip?.startDate)!
            endDate.date = (selectedTrip?.endDate)!
        }else{
            navItem.title = Constants.newTripTitle
        }
        
    }
}