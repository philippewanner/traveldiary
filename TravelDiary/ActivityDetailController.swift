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

class ActivityDetailController: UIViewController {
    
    private struct Constants{
        static let SaveActivitySegue = "SaveActivity"
        static let SelectLocationSegue = "SelectLocation"
        static let ViewPhotoSegue = "viewPhotoSegue"
        static let ImageReuseIdentifier = "imageReuseIndentifier"
    }
    
    @IBOutlet weak var activityDescription: UITextField!
    @IBOutlet weak var activityDate: UIDatePicker!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var activityTitle: UITextField!
    @IBOutlet weak var activityPhotoCollectionView: UICollectionView!
    
    // Selected Activity from the Activity tabel
    var selectedActivity: Activity?
    // Location placemark from the search
    var selectedPlacemark: MKPlacemark?
    // Whether the Photo was made with the camera or imported from the library
    private var fromCamera: Bool = false
    //For Updating the collection view
    private var blockOperations: [NSBlockOperation] = []
    // Controller to load data
    private var fetchedResultsController: NSFetchedResultsController!
    
    /*!
        Init method for the fetchedController defining the predicte to load data
    */
    private func initializeFetchedResultsController(){
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
    
    /*!
        Segue calls to other ViewControllers
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.SaveActivitySegue {
            selectedActivity = selectedActivity ?? Activity(managedObjectContext: self.managedObjectContext)
            selectedActivity?.descr = activityDescription.text
            selectedActivity?.date = activityDate.date

            let location = selectedActivity?.location ?? Location(managedObjectContext: self.managedObjectContext)
            if let selectedPlacemark = selectedPlacemark {
                location.address = selectedPlacemark.formattedAddressLines()
                location.coordinate = selectedPlacemark.coordinate
                location.countryCode = selectedPlacemark.countryCode
                location.inActivity = selectedActivity
            }
            location.name = locationName.text
            
        } else if segue.identifier == Constants.SelectLocationSegue {
            let navController = segue.destinationViewController as! UINavigationController
            let activityLocationController = navController.topViewController as!ActivityLocationController
            activityLocationController.selectedOnMap = selectedPlacemark
            activityLocationController.existingLocation = selectedActivity?.location
        } else if segue.identifier == Constants.ViewPhotoSegue {
            let imageViewController = segue.destinationViewController as! ImageViewController
            let cell = sender as! ActivityPhotoCell
            let indexPath = self.activityPhotoCollectionView!.indexPathForCell(cell)
            let selectedPhoto = fetchedResultsController.objectAtIndexPath(indexPath!) as? Photo
            imageViewController.image = (selectedPhoto?.image)!
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
    
    /*!
        segue to return from the image view.
    */
    @IBAction func unwindSegueBackToActivity(segue: UIStoryboardSegue){}
    
    /*!
        Access photo library to import a photo
    */
    @IBAction func accessPhotoLibrary(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        fromCamera = false

    }
    
    /*!
        Make a picture using the build in camera functionality
    */
    @IBAction func takePicture(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            picker.sourceType = .Camera
            presentViewController(picker, animated: true, completion: nil)
            fromCamera = true
        }

    }
    
    // Cancel all block operations when ViewController deallocates
    deinit {
        for operation: NSBlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepCapacity: false)
    }
}


//MARK: - UINavigationControllerDelegate - Delegate for save action on the camera
extension ActivityDetailController: UINavigationControllerDelegate{
    
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

//MARK: - UIImagePickerControllerDelegate - Delegate for the save action on the PickerController
extension ActivityDetailController: UIImagePickerControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let imageCameraOrLibrary = info [UIImagePickerControllerOriginalImage] as? UIImage;
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

//MARK: - UICollectionViewDataSource - Datasource for the CollectionView which fetches from the FetchedResultController
extension ActivityDetailController: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ImageReuseIdentifier, forIndexPath: indexPath) as! ActivityPhotoCell
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







