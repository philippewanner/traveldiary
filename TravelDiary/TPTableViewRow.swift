//
//  TripViewCell.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 08/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class TPTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    var sectionNumber = 0
    
}

extension TPTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set {
            collectionView.contentOffset.x = newValue
        }
        
        get {
            return collectionView.contentOffset.x
        }
    }
}
