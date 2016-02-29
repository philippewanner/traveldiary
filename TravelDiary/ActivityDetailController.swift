//
//  CurrentTripDetailController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 21/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class ActivityDetailController: UIViewController {
    
    var selectedActivity: Activity?
    let dateFormatter = NSDateFormatter()
    
    
    @IBOutlet weak var activityDescription: UITextField!
  
    @IBOutlet weak var activityDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.locale = NSLocale(localeIdentifier: "de_CH")
        if selectedActivity != nil{
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            activityDescription.text = selectedActivity?.descr
            activityDate.date = (selectedActivity?.date)!
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveActivity"{
            if selectedActivity == nil{
                selectedActivity = Activity(managedObjectContext: self.managedObjectContext)
            }
            selectedActivity?.descr = activityDescription.text
            selectedActivity?.date = activityDate.date
        }
    }
}
