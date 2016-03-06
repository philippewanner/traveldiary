//
//  CurrentTripDetailController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 21/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class ActivityDetailController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedActivity: Activity?
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var activityDescription: UITextField!
  
    @IBOutlet weak var activityDate: UIDatePicker!
    
    @IBOutlet weak var locationName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.locale = NSLocale(localeIdentifier: "de_CH")
        if selectedActivity != nil{
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            activityDescription.text = selectedActivity?.descr
            activityDate.date = (selectedActivity?.date)!
            locationName.text = selectedActivity?.location?.name
            locationName.userInteractionEnabled = false
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
    
    /*!
    segue which is called when the cancel button on the AddChangeLocationController is called
    */
    @IBAction func unwindSegueCancelLocation(segue:UIStoryboardSegue) {}
    
    /*!
    segue which is called when the save button on the ActivityDetailContoller is pressed
    */
    @IBAction func unwindSequeSaveLocation(segue: UIStoryboardSegue){
        if let addChangeLocationController = segue.sourceViewController as? AddChangeLocationController {
            _ = addChangeLocationController.newLocation
        }
    }
    
  
//    @IBAction func takePicture(sender: UIButton) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .Camera
//        
//        presentedViewController?.presentViewController(picker, animated: true, completion: nil)
//        
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        image.image = info [UIImagePickerControllerOriginalImage] as? UIImage;
//        dismissViewControllerAnimated(true, completion: nil)
//    }
}
