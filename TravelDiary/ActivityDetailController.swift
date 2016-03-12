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
    var fromCamera: Bool = false

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
            let photoData = Photo(managedObjectContext: self.managedObjectContext)
            photoData.image = image.image
            photoData.createDate = NSDate()
            selectedActivity?.addPhoto(photoData)
            if fromCamera{
                //Only save photo to the libary if it was made with the camera
                UIImageWriteToSavedPhotosAlbum(image.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
            }
        } else if segue.identifier == "SelectLocation" {
            let navController = segue.destinationViewController as! UINavigationController
            let activityLocationController = navController.topViewController as!ActivityLocationController
            activityLocationController.existingLocation = selectedActivity?.location
        }
    }

    
    // MARK: Navigation
    // segue which is called when the save button on the modal location dialog is pressed
    @IBAction func unwindSequeSaveLocation(segue: UIStoryboardSegue){
        if let selectLocationController = segue.sourceViewController as? ActivityLocationController {
            if let mapItem = selectLocationController.selectedOnMap {
                var location = selectedActivity?.location
                if location == nil {
                    location = Location(managedObjectContext: managedObjectContext)
                }
                location?.name = mapItem.name
                location?.address = mapItem.placemark.formattedAddressLines()
                location?.coordinate = mapItem.placemark.coordinate
                location?.countryCode = mapItem.placemark.countryCode
            }
        }
    }

    @IBAction func accessPhotoLibrary(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        fromCamera = false

    }
    @IBAction func takePicture(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            picker.sourceType = .Camera
            presentViewController(picker, animated: true, completion: nil)
            fromCamera = true
        }

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





