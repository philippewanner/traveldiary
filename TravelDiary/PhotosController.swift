//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Philippe Wanner on 02/03/16.
//  Copyright © 2016 Philippe Wanner. All rights reserved.
//

import UIKit

class PhotosController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let titles = ["title1", "title2", "title3", "title4", "title5", "title6", "title7", "title8", "title9", "title10"]
    
    let images = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4"), UIImage(named: "image5"), UIImage(named: "image6"), UIImage(named: "image7"), UIImage(named: "image8"), UIImage(named: "image9"), UIImage(named: "image10")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            controller.image = self.images[indexPath.row]!
            
            //Set the title of this image depending of the selected item in the collection view
            controller.title = self.titles[indexPath.row]
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //When someone clicks on the cell
        NSLog("click on image")
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        NSLog("load image&title number %i in a cell", indexPath.row)
        cell.imageView?.image = self.images[indexPath.row]
        
        cell.titleLabel?.text = self.titles[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //For the number of cells in our collection
        return self.titles.count
    }
    
    
}

