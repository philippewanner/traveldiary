////
////  TripPhotosDataSource.swift
////  TravelDiary
////
////  Created by Philippe Wanner on 11/03/16.
////  Copyright © 2016 PTPA. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class TripPhotosDataSource: UICollectionViewDataSource {
//    
//    let model = generateRandomData()
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return model[collectionView.tag].count
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tripPhotoCell", forIndexPath: indexPath)
//        
//        cell.backgroundColor = model[collectionView.tag][indexPath.item]
//        
//        return cell
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
//    }
//}