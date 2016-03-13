//
//  TPCollectionViewDataSource.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 13/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class TPTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    var data : [Photo] = []
    var viewController = UIViewController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tripPhotoCell", forIndexPath: indexPath) as! TPCollectionViewCell
        
        NSLog("load image #%i in a TPTableViewCell", indexPath.row)
        cell.imageView.image = data[indexPath.row].image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NSLog("%d images in trip", data.count)
        return data.count
    }
    

}