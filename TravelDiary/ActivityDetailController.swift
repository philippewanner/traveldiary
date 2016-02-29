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
