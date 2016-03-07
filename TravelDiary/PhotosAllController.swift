//
//  PhotosAllController.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class PhotosAllController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Data Source for UICollectionView
    var collectionViewDataSource = CollectionDataSource()
    
    // Core Data managed context
    var managedContext : NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("wiewDidLoad")
        // setup Core Data context
        coreDataSetup()
        // load photos in memory
        loadPhotos()
        // Attached the data source to the collection view
        collectionView.dataSource = collectionViewDataSource
        //Update total photos label
        totalLabel.text = String(collectionViewDataSource.data.count) + " photos"
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
            controller.image = self.collectionViewDataSource.data[indexPath.row].image
            
            //Set the title of this image depending of the selected item in the collection view
            controller.title = self.collectionViewDataSource.data[indexPath.row].title
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //When someone clicks on the cell
        NSLog("click on image")
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    
    func loadPhotos(){
        
        NSLog("loadPhotos")
        // loadCoreDataImages fct with a completion block
        loadCoreDataImages { (images) -> Void in
            NSLog("loadCoreDataImages in")
            if let images = images {
                
                self.collectionViewDataSource.data += images.map { return (image:$0.image ?? UIImage(),title:$0.title ?? "") }
                
                NSLog("start dataSource:%d", self.collectionViewDataSource.data.count)
                
            } else {
                self.noImagesFound()
            }
        }
    }
}