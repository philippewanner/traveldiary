//
//  ViewActivityController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 14/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class ViewActivityController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedActivity: Activity?
    
    private struct Constants{
        static let EditActivitySegue = "EditActivitySeque"
        static let ImageReuseIdentifier = "ImageReuseIdentifier"
    }
    
    private var blockOperations: [NSBlockOperation] = []
    private var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.textContainer.lineFragmentPadding = 0;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = selectedActivity!.title
        
        subtitleLabel.text = selectedActivity!.dateAsString
        subtitleLabel.hidden = subtitleLabel.text == nil
        
        textView.text = selectedActivity!.descr
        textView.hidden = textView.text == nil
        
        initializeFetchedResultsController()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
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
}

//MARK: - UICollectionViewDataSource - Datasource for the CollectionView which fetches from the FetchedResultController
extension ViewActivityController: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ImageReuseIdentifier, forIndexPath: indexPath) as! ActivityPhotoCell
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        cell.activityPhoto.image = photo.thumbnail
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
extension ViewActivityController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        blockOperations.removeAll(keepCapacity: false)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if type == NSFetchedResultsChangeType.Insert {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.insertItemsAtIndexPaths([newIndexPath!])
                    }
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.Update {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.reloadItemsAtIndexPaths([indexPath!])
                    }
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.Move {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.moveItemAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                    }
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.Delete {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.deleteItemsAtIndexPaths([indexPath!])
                    }
                    })
            )
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.performBatchUpdates({ () -> Void in
            for operation: NSBlockOperation in self.blockOperations {
                operation.start()
            }
            }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepCapacity: false)
        })
    }
}

