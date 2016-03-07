//
//  CollectionDataSource.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class CollectionDataSource: NSObject, UICollectionViewDataSource {
    
//    var data : [(image:UIImage,id:NSNumber)] = []
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        if let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as? ImageDisplayCell {
//            
//            cell.thumbnailView.image = data[indexPath.row].image
//            let dateNumber = Double(data[indexPath.row].id)
//            let date = NSDate(timeIntervalSince1970: dateNumber)
//            cell.label.text = ImageDisplayCell.dateFormatter.stringFromDate(date)
//            
//            return cell
//            
//        }
//        
//        return UITableViewCell()
//    }
    
    var titles = ["title1", "title2", "title3", "title4", "title5", "title6", "title7", "title8", "title9", "title10"]
    
    var images = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3"), UIImage(named: "image4"), UIImage(named: "image5"), UIImage(named: "image6"), UIImage(named: "image7"), UIImage(named: "image8"), UIImage(named: "image9"), UIImage(named: "image10")]
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        NSLog("load image&title number %i in a cell", indexPath.row)
        cell.imageView?.image = self.images[indexPath.row]
        //        let photo = (fetchedResultsController.objectAtIndexPath(indexPath) as! Photo)
        
        
        cell.titleLabel?.text = self.titles[indexPath.row]
        //        cell.imageView?.image = photo
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //For the number of cells in our collection
        //        return fetchedResultsController.sections?.count ?? 0
        return images.count
    }
}
