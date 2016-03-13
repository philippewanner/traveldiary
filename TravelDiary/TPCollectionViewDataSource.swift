//
//  TPCollectionViewDataSource.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 13/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class TPTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var data : [Photo] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tripPhotoCell", forIndexPath: indexPath) as! TPCollectionViewCell
        
        NSLog("load image #%i in a TPTableViewCell", indexPath.row)
        cell.imageView.image = data[indexPath.row].image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count =  data.count
        NSLog("%d images in trip", count)
        return count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view selected index path \(indexPath.item)")
    }
}