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
    @IBOutlet weak var startDateAlertMessage: UILabel!
    @IBOutlet weak var endDatePickerStackView: UIStackView!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var endDateAlertMessage: UILabel!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    enum TripDateType {
        case Start, End
    }
    
    private struct Constants{
        static let editTripTitle = "Edit Trip"
        static let newTripTitle = "New Trip"
        static let saveTripSegue = "saveTripUnwindSegue"
        static let cancelTripSegue = "cancelEditTripUnwindSegue"
        static let defaultStartToEndDateDaysOffset: Int = 7
        static let alertMessageDateFormat = "dd.MM.yyyy"
        static let dateTextFieldDateFormat = "EEEE, dd. MMMM yyyy"
    }
    private let dateFormatter = NSDateFormatter()
    private var startDateBeforeEditing = NSDate()
    private var endDateBeforeEditing = NSDate()
    var trips: [Trip] = []
    var conflictingTrips: [Trip] = []
    var currentTrip: Trip?
    
    @IBAction func titleEditingChanged(title: UITextField) {
        if self.isTitleNotNullOrEmpty(){
            enableSaveButtonIfNoConflictsExists()
        }else{
            disableSaveButton()
        }
    }
    
    @IBAction func startDateEditingDidBegin(startDate: UITextField) {
        NSLog("startDateEditingDidBegin()")
        startDateBeforeEditing = startDatePicker.date
        startDatePickerStackView.hidden = false
        startDate.userInteractionEnabled = false
    }
    
    @IBAction func startDateEditingDidEnd(startDate: UITextField) {
        NSLog("startDateEditingDidEnd()")
        startDatePickerStackView.hidden = true
        startDateTextField.userInteractionEnabled = true
    }
    
    @IBAction func endDateEditingDidBegin(endDate: UITextField) {
        NSLog("endDateEditingDidBegin()")
        endDateBeforeEditing = endDatePicker.date
        endDatePickerStackView.hidden = false
        endDate.userInteractionEnabled = false
    }
    
    @IBAction func endDateEditingDidEnd(endDate: UITextField) {
        NSLog("endDateEditingDidEnd()")
        endDatePickerStackView.hidden = true
        endDate.userInteractionEnabled = true
    }
    
    @IBAction func startDatePickerValueChanged(startDatePicker: UIDatePicker) {
        self.startDateTextField.text = getStringFromDate(startDatePicker.date)
        self.checkConflictsAndAdaptUserFeedbackFor(TripDateType.Start)
    }
    
    @IBAction func endDatePickerValueChanged(endDatePicker: UIDatePicker) {
        self.endDateTextField.text = getStringFromDate(endDatePicker.date)
        self.checkConflictsAndAdaptUserFeedbackFor(TripDateType.End)
    }
    
    /*!
        Dismiss the keyboard when pressing return
    */
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDatePickerDateFormatterProperties()
        self.hideDatePickersAlertMessages()
        self.setKnownData()
        disableSaveButton()
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
    
    private func checkConflictsAndAdaptUserFeedbackFor(tripDateType: TripDateType){
        self.changeEndDateIfStartDateIsNewer()
        self.checkDateRanges()
        if self.isCurrentDateRangeConflicting() {
            let alertMessage = getAlertMessage()
            switch tripDateType {
            case .Start:
                self.showStartDateAlertMessage(alertMessage)
            case .End:
                self.showEndDateAlertMessage(alertMessage)
            }
            self.disableSaveButton()
        }else{
            self.hideAndClearAlerts()
            self.enableSaveButtonIfTitleIsSet()
        }
    }
    
    private func getAlertMessage() -> NSString{
        return self.getDateRangeConflictingMessage(requestedDateStart: startDatePicker.date, requestedDateEnd: endDatePicker.date)
    }
    
    private func enableSaveButtonIfNoConflictsExists(){
        if !self.isCurrentDateRangeConflicting(){
            self.enableSaveButton()
        }
    }
    
    private func enableSaveButtonIfTitleIsSet(){
        if self.isTitleNotNullOrEmpty(){
            self.enableSaveButton()
        }
    }
    
    private func isTitleNotNullOrEmpty() -> Bool{
        return self.isNotNullOrEmpty(tripTitle.text)
    }
    
    private func checkDateRanges(){
        self.filterDateRangeConflictingTrips(startDate: self.startDatePicker.date, endDate: self.endDatePicker.date)
    }
    
    private func getDateRangeConflictingMessage(requestedDateStart requestedDateStart: NSDate, requestedDateEnd: NSDate) -> NSString {
        self.setAlertMessageDateFormatterProperties()
        
        var message = "The requested period '"
            message += getStringFromDate(requestedDateStart) + " - " + getStringFromDate(requestedDateEnd)
            message += "' must not overlap existing period(s): \r\n\r\n"
        for trip in conflictingTrips {
            if let title = trip.title {
                message += " " + title + ": "
            }
            if let startDate = trip.startDate {
                message += getStringFromDate(startDate) + " - "
            }
            if let endDate = trip.endDate {
                message += getStringFromDate(endDate)
            }
            message += "\r\n"
        }
        
        self.setDatePickerDateFormatterProperties()
        return message
    }
    
    private func enableSaveButton(){
        saveBarButtonItem.enabled = true
    }
    
    private func disableSaveButton(){
        saveBarButtonItem.enabled = false
    }
    
    private func hideAndClearAlerts(){
        self.hideAndClearEndDateAlertMessage()
        self.hideAndClearStartDateAlertMessage()
    }
    
    private func showEndDateAlertMessage(message: NSString){
        self.endDateAlertMessage.hidden = false
        self.endDateAlertMessage.text = message as String
    }
    
    private func hideAndClearEndDateAlertMessage(){
        self.endDateAlertMessage.hidden = true
        self.endDateAlertMessage.text = ""
    }
    
    private func showStartDateAlertMessage(message: NSString){
        self.startDateAlertMessage.hidden = false
        self.startDateAlertMessage.text = message as String
    }
    
    private func hideAndClearStartDateAlertMessage(){
        self.startDateAlertMessage.hidden = true
        self.startDateAlertMessage.text = ""
    }
    
    private func isCurrentDateRangeConflicting() -> Bool {
        return self.conflictingTrips.count > 0
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
            self.setStartDate(defaultStartDate)
            self.setEndDate(defaultStartDate.addDays(Constants.defaultStartToEndDateDaysOffset))
            self.disableSaveButton()
        }else{
            self.navItem.title = Constants.editTripTitle
            self.tripTitle.text = currentTrip?.title
            if let startDate = currentTrip?.startDate {
                self.setStartDate(startDate)
            }
            if let endDate = currentTrip?.endDate{
                self.setEndDate(endDate)
            }
        }
    }
    
    private func setAlertMessageDateFormatterProperties(){
        self.dateFormatter.locale = NSLocale.currentLocale()
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.dateFormat = Constants.alertMessageDateFormat
    }
    
    private func setDatePickerDateFormatterProperties(){
        self.dateFormatter.locale = NSLocale.currentLocale()
        self.dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        self.dateFormatter.dateFormat = Constants.dateTextFieldDateFormat
    }
    
    private func hideDatePickersAlertMessages(){
        startDatePickerStackView.hidden = true
        endDatePickerStackView.hidden = true
        startDateAlertMessage.hidden = true
        endDateAlertMessage.hidden = true
    }
    
    private func filterDateRangeConflictingTrips(startDate startDate: NSDate, endDate: NSDate){
        self.conflictingTrips = trips.filter { trip in
            if trip == self.currentTrip {
                return false
            }
            
            if let currentStartDate = trip.startDate {
                let startDateIsOlder = isFirstDateOlderThanSecondDate(first: startDate, second: currentStartDate)
                let endDateIsOlder = isFirstDateOlderThanSecondDate(first: endDate, second: currentStartDate)
                if startDateIsOlder && endDateIsOlder {
                    NSLog("requested period '\(startDate) - \(endDate)' is not overlapping the current start date '\(currentStartDate)'")
                    return false
                }
                
                if let currentEndDate = trip.endDate {
                    let startDateIsNewer = isFirstDateNewerThanSecondDate(first: startDate, second: currentEndDate)
                    let endDateIsNewer = isFirstDateNewerThanSecondDate(first: endDate, second: currentEndDate)
                    if startDateIsNewer && endDateIsNewer {
                        NSLog("requested period '\(startDate) - \(endDate)' is not overlapping the current period '\(currentStartDate) - \(currentEndDate)'")
                        return false
                    }
                    NSLog("requested period '\(startDate) - \(endDate)' is overlapping the current period '\(currentStartDate) - \(currentEndDate)'")
                    return true
                }
            }
            return false
        }
    }
    
    private func isFirstDateOlderOrEqualToSecondDate(first firstDate: NSDate, second secondDate: NSDate) -> Bool{
        let firstDateIsNewer = isFirstDateNewerThanSecondDate(first: firstDate, second: secondDate)
        let firstDateIsEqual = isFirstDateEqualToSecondDate(first: firstDate, second: secondDate)
        return !firstDateIsNewer || firstDateIsEqual
    }
    
    private func isFirstDateNewerOrEqualToSecondDate(first firstDate: NSDate, second secondDate: NSDate) -> Bool{
        let firstDateIsNewer = isFirstDateNewerThanSecondDate(first: firstDate, second: secondDate)
        let firstDateIsEqual = isFirstDateEqualToSecondDate(first: firstDate, second: secondDate)
        return firstDateIsNewer || firstDateIsEqual
    }
    
    private func isFirstDateEqualToSecondDate(first firstDateToCompare: NSDate, second secondDateToCompare: NSDate) -> Bool{
        var firstDateIsEqual = false
        let firstDate = self.overrideDateTime(firstDateToCompare)
        let secondDate = self.overrideDateTime(secondDateToCompare)
        
        let dateComparisionResult:NSComparisonResult = firstDate.compare(secondDate)
        if dateComparisionResult == NSComparisonResult.OrderedSame {
            firstDateIsEqual = true
        }
        NSLog("\(firstDateToCompare) is equal to \(secondDateToCompare) => \(firstDateIsEqual)")
        return firstDateIsEqual
    }
    
    private func isFirstDateOlderThanSecondDate(first firstDateToCompare: NSDate, second secondDateToCompare: NSDate) -> Bool{
        var datesAreEqual = false
        var firstDateIsOlder = false
        let firstDate = self.overrideDateTime(firstDateToCompare)
        let secondDate = self.overrideDateTime(secondDateToCompare)
        
        let firstDateIsNewer = self.isFirstDateNewerThanSecondDate(first: firstDate, second: secondDate)
        if !firstDateIsNewer{
            datesAreEqual = isFirstDateEqualToSecondDate(first: firstDate, second: secondDate)
            if !datesAreEqual {
                firstDateIsOlder = true
            }
        }
        NSLog("\(firstDate) is older than \(secondDate) => \(firstDateIsOlder)")
        return firstDateIsOlder
    }
    
    private func isFirstDateNewerThanSecondDate(first firstDateToCompare: NSDate, second secondDateToCompare: NSDate) -> Bool{
        var firstDateIsNewer = false
        let firstDate = self.overrideDateTime(firstDateToCompare)
        let secondDate = self.overrideDateTime(secondDateToCompare)
        
        let dateComparisionResult:NSComparisonResult = firstDate.compare(secondDate)
        if dateComparisionResult == NSComparisonResult.OrderedDescending{
            firstDateIsNewer = true
        }
        NSLog("\(firstDate) is newer than \(secondDate) => \(firstDateIsNewer)")
        return firstDateIsNewer
    }
    
    private func overrideDateTime(dateToOverride: NSDate) -> NSDate {
        let cal: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let midnightDateTime: NSDate = cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: dateToOverride, options: NSCalendarOptions())!
        NSLog("override  '\(dateToOverride)' to '\(midnightDateTime)'")
        return midnightDateTime
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