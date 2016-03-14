//
//  CollectionViewCell.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var photo: Photo!
}