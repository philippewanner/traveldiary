//
//  CurrentTripDetailController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 21/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class ActivityDetailController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var selectedActivity: Activity?
    
    @IBOutlet weak var activityDescription: UITextField!
    @IBOutlet weak var activityDate: UIDatePicker!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedActivity = selectedActivity {
            activityDescription.text = selectedActivity.descr
            activityDate.date = selectedActivity.date!
            locationName.text = selectedActivity.location?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveActivity" {
            selectedActivity = selectedActivity ?? Activity(managedObjectContext: self.managedObjectContext)
            selectedActivity?.descr = activityDescription.text
            selectedActivity?.date = activityDate.date
            if locationName.text == nil {
                selectedActivity?.location = nil
            }
            let photoData = Photo(managedObjectContext: self.managedObjectContext)
            photoData.image = image.image
            photoData.createDate = NSDate()
            selectedActivity?.addPhoto(photoData)
            UIImageWriteToSavedPhotosAlbum(image.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
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
    
    @IBAction func accessPhotoLibrary(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        
    }
    @IBAction func takePicture(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            picker.sourceType = .Camera
        }
        presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image.image = info [UIImagePickerControllerOriginalImage] as? UIImage;
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
}





