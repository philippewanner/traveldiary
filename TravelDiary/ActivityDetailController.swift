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
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityDescription: UITextField!
    @IBOutlet weak var activityDate: UIDatePicker!
    @IBOutlet weak var locationName: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedActivity = selectedActivity {
            activityDescription.text = selectedActivity.descr
            activityDate.date = selectedActivity.date!
            locationName.text = selectedActivity.location?.name
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveActivity" {
            selectedActivity = selectedActivity ?? Activity(managedObjectContext: self.managedObjectContext)
            selectedActivity?.descr = activityDescription.text
            selectedActivity?.date = activityDate.date
            if locationName.text == nil {
                selectedActivity?.location = nil
            }
        } else if segue.identifier == "SelectLocation" {
            let navController = segue.destinationViewController as! UINavigationController
            let selectLocationController = navController.topViewController as!ActivitySelectLocationController
            selectLocationController.selectedLocation = selectedActivity?.location
        }
    }
    
    /*!
    segue which is called when the cancel button on the  modal map view is pressed
    */
    @IBAction func unwindSegueCancelLocation(segue:UIStoryboardSegue) {
    }
    
    /*!
    segue which is called when the save button on the modal map view is pressed
    */
    @IBAction func unwindSequeSaveLocation(segue: UIStoryboardSegue){
        if let selectLocationController = segue.sourceViewController as? ActivitySelectLocationController {
            selectedActivity?.location = selectLocationController.selectedLocation
        }
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

