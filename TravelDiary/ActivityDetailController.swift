//
//  CurrentTripDetailController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 21/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ActivityDetailController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var activityDescription: UITextField!
    @IBOutlet weak var activityDate: UIDatePicker!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var activityTitle: UITextField!
    @IBOutlet weak var activityPhotoCollectionView: UICollectionView!
    
    var selectedActivity: Activity?
    var selectedPlacemark: MKPlacemark?
    var fromCamera: Bool = false
    var imageCameraOrLibrary : UIImage?
    //For Updating the collection view
    var blockOperations: [NSBlockOperation] = []
    
    var fetchedResultsController: NSFetchedResultsController!
    
    func initializeFetchedResultsController(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: Photo.entityName())
        fetchRequest.predicate = NSPredicate(format: "inActivity == %@", selectedActivity!)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedActivity = selectedActivity {
            activityDescription.text = selectedActivity.descr
            activityDate.date = selectedActivity.date!
            locationName.text = selectedActivity.location?.name
            activityTitle.text = selectedActivity.title
            
            initializeFetchedResultsController()
            do {
                try fetchedResultsController.performFetch()
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.userInfo)")
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveActivity" {
            selectedActivity = selectedActivity ?? Activity(managedObjectContext: self.managedObjectContext)
            selectedActivity?.descr = activityDescription.text
            selectedActivity?.date = activityDate.date
            
            
            if let selectedPlacemark = selectedPlacemark {
                let location = selectedActivity?.location ?? Location(managedObjectContext: self.managedObjectContext)
                location.name = selectedPlacemark.name
                location.address = selectedPlacemark.formattedAddressLines()
                location.coordinate = selectedPlacemark.coordinate
                location.countryCode = selectedPlacemark.countryCode
                selectedActivity?.location = location
            }
        } else if segue.identifier == "SelectLocation" {
            let navController = segue.destinationViewController as! UINavigationController
            let activityLocationController = navController.topViewController as!ActivityLocationController
            activityLocationController.selectedOnMap = selectedPlacemark
            activityLocationController.existingLocation = selectedActivity?.location
        }
    }

    
    /*!
        segue which is called when the save button on the modal location dialog is pressed
    */
    @IBAction func unwindSequeSaveLocation(segue: UIStoryboardSegue){
        if let selectLocationController = segue.sourceViewController as? ActivityLocationController {
            selectedPlacemark = selectLocationController.selectedOnMap
            locationName.text = selectedPlacemark?.name
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
    
    deinit {
        // Cancel all block operations when ViewController deallocates
        for operation: NSBlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepCapacity: false)
    }

    
}
extension ActivityDetailController: UIImagePickerControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageCameraOrLibrary = info [UIImagePickerControllerOriginalImage] as? UIImage;
        if imageCameraOrLibrary != nil{
            let photoData = Photo(managedObjectContext: self.managedObjectContext)
            photoData.image = imageCameraOrLibrary
            photoData.createDate = NSDate()
            photoData.title = selectedActivity?.title
            photoData.inActivity = selectedActivity
            self.saveContext()
            if fromCamera{
                UIImageWriteToSavedPhotosAlbum(imageCameraOrLibrary!, self, "image:didFinishSavingWithError:contextInfo:", nil)
            }
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ActivityDetailController: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageReuseIndentifier", forIndexPath: indexPath) as! ActivityPhotoCell
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        cell.activityPhoto.image = photo.image
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
}
// MARK: - NSFetchedResultsControllerDelegate
/* 
    NSFetchResulteControllerDelegate works differently with a UICollectionView
    http://stackoverflow.com/questions/20554137/nsfetchedresultscontollerdelegate-for-collectionview
*/
extension ActivityDetailController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        blockOperations.removeAll(keepCapacity: false)
    }
        
    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if type == NSFetchedResultsChangeType.Insert {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.activityPhotoCollectionView.insertItemsAtIndexPaths([newIndexPath!])
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.Update {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.activityPhotoCollectionView.reloadItemsAtIndexPaths([indexPath!])
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.Move {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                       this.activityPhotoCollectionView.moveItemAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.Delete {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.activityPhotoCollectionView.deleteItemsAtIndexPaths([indexPath!])
                    }
                })
            )
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        activityPhotoCollectionView.performBatchUpdates({ () -> Void in
            for operation: NSBlockOperation in self.blockOperations {
                operation.start()
            }
            }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepCapacity: false)
        })
    }
}







