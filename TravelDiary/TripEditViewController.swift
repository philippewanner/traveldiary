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
    
    @IBOutlet var navItem: UINavigationItem!
    @IBOutlet weak var tripTitle: UITextField!
    @IBOutlet weak var startDatePickerStackView: UIStackView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDatePickerStackView: UIStackView!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endDateTextField: UITextField!
    
    private struct Constants{
        static let editTripTitle = "Edit Trip"
        static let newTripTitle = "New Trip"
        static let saveTripSegue = "saveTripUnwindSegue"
        static let cancelTripSegue = "cancelEditTripUnwindSegue"
        static let defaultStartToEndDateDaysOffset: Int = 7
    }
    private let dateFormatter = NSDateFormatter()
    var currentTrip: Trip?
    
    @IBAction func startDateEditingDidBegin(startDate: UITextField) {
        NSLog("startDateEditingDidBegin()")
        startDatePickerStackView.hidden = false
        startDate.userInteractionEnabled = false
    }
    
    @IBAction func startDateEditingDidEnd(startDate: UITextField) {
        NSLog("startDateEditingDidEnd()")
        startDatePickerStackView.hidden = true
        startDateTextField.userInteractionEnabled = true
        changeEndDateIfStartDateIsNewer()
    }
    
    @IBAction func endDateEditingDidBegin(endDate: UITextField) {
        NSLog("endDateEditingDidBegin()")
        endDatePickerStackView.hidden = false
        endDate.userInteractionEnabled = false
    }
    
    @IBAction func endDateEditingDidEnd(endDate: UITextField) {
        NSLog("endDateEditingDidEnd()")
        endDatePickerStackView.hidden = true
        endDate.userInteractionEnabled = true
        self.changeEndDateIfStartDateIsNewer()
    }
    
    @IBAction func startDatePickerValueChanged(startDatePicker: UIDatePicker) {
        self.startDateTextField.text = getStringFromDate(startDatePicker.date)
    }
    
    @IBAction func endDatePickerValueChanged(endDatePicker: UIDatePicker) {
        self.endDateTextField.text = getStringFromDate(endDatePicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDateFormatterProperties()
        self.hideDatePickers()
        self.setKnownData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.saveTripSegue {
            NSLog("prepare for segue '\(Constants.saveTripSegue)'")
            if isNotNullOrEmpty(tripTitle.text) {
                prepareTripDataToSave()
            }else{
                NSLog("no trip title set!")
            }
        }else if segue.identifier == Constants.cancelTripSegue {
            NSLog("prepare for segue '\(Constants.cancelTripSegue)'")
        }
    }
    
    private func changeEndDateIfStartDateIsNewer(){
        let currentStartDate = self.startDatePicker.date
        let currentEndDate = self.endDatePicker.date
        if self.isFirstDateNewerThanSecondDate(first: currentStartDate, second: currentEndDate){
            NSLog("start date is newer than end date, end date will be changed to '\(currentStartDate)")
            self.setEndDate(currentStartDate)
        }
    }
    
    private func setStartDate(startDate: NSDate){
        self.startDatePicker.date = startDate
        self.startDatePickerValueChanged(self.startDatePicker)
    }
    
    private func setEndDate(endDate: NSDate){
        self.endDatePicker.date = endDate
        self.endDatePickerValueChanged(self.endDatePicker)
    }
    
    private func prepareTripDataToSave(){
        if self.currentTrip == nil {
            self.currentTrip = Trip(managedObjectContext: self.managedObjectContext)
            NSLog("added new trip: '\(tripTitle.text!)'")
        }else{
            NSLog("edited trip: '\(tripTitle.text!)'")
        }
        self.currentTrip?.title = tripTitle.text
        self.currentTrip?.startDate = self.startDatePicker.date
        self.currentTrip?.endDate = self.endDatePicker.date
    }
    
    private func setKnownData(){
        NSLog("setting known trip data")
        if self.currentTrip == nil {
            self.navItem.title = Constants.newTripTitle
            let defaultStartDate = NSDate()
            setStartDate(defaultStartDate)
            setEndDate(defaultStartDate.addDays(Constants.defaultStartToEndDateDaysOffset))
        }else{
            self.navItem.title = Constants.editTripTitle
            self.tripTitle.text = currentTrip?.title
            if let startDate = currentTrip?.startDate {
                setStartDate(startDate)
            }
            if let endDate = currentTrip?.endDate{
                setEndDate(endDate)
            }
        }
    }
    
    private func setDateFormatterProperties(){
        self.dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        self.dateFormatter.locale = NSLocale.currentLocale()
    }
    
    private func hideDatePickers(){
        startDatePickerStackView.hidden = true
        endDatePickerStackView.hidden = true
    }
    
    private func isFirstDateNewerThanSecondDate(first firstDate: NSDate, second secondDate: NSDate) -> Bool{
        var firstDateIsNewer = false
        let dateComparisionResult:NSComparisonResult = firstDate.compare(secondDate)
        if dateComparisionResult == NSComparisonResult.OrderedDescending{
            firstDateIsNewer = true
        }
        return firstDateIsNewer
    }
    
    private func getStringFromDate(date: NSDate)-> String{
        return self.dateFormatter.stringFromDate(date)
    }
    
    private func isNotNullOrEmpty(aString: NSString?) -> Bool{
        if let currentSting = aString {
            if currentSting.trim() != "" {
                return true
            }
        }
        return false
    }
}