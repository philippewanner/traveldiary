//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Philippe Wanner on 02/03/16.
//  Copyright © 2016 Philippe Wanner. All rights reserved.
//

import UIKit
import CoreData

class PhotosController: UIViewController, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var fetchedResultsController:NSFetchedResultsController!
    // Data Source for UICollectionView
    var collectionViewDataSource = CollectionDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = collectionViewDataSource
        
        self.initializeFetchedResultsController()
        
        self.fetchTripsData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showImage" {
            NSLog("showImage")
            //Get the number of items selected in the collection view
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            //Get the first items of those
            let indexPath = indexPaths[0] as NSIndexPath
            
            //Cast the destination view controller to ImageViewController
            let controller = segue.destinationViewController as! ImageViewController
            
            //Set the image in the ImageViewController to the selected item in the collection view
            controller.image = self.collectionViewDataSource.images[indexPath.row]!
            
            //Set the title of this image depending of the selected item in the collection view
            controller.title = self.collectionViewDataSource.titles[indexPath.row]
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //When someone clicks on the cell
        NSLog("click on image")
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    
    private func fetchTripsData() {
        do {
            try fetchedResultsController.performFetch()
            NSLog("data fetching successfully accomplished")
        } catch {
            let fetchError = error as NSError
            NSLog("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    private func initializeFetchedResultsController(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: Trip.entityName())
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
    }
    
}

