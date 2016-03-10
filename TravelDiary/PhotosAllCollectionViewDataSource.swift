//
//  CollectionDataSource.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class CollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var data : [(image:UIImage, title: String)] = []
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        NSLog("load image&title number %i in a cell", indexPath.row)
        cell.imageView.image = data[indexPath.row].image
        cell.titleLabel.text = data[indexPath.row].title
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
}
