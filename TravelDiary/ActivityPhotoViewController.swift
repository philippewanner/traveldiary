//
//  ActivityPhotoViewController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 13/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class ActivityPhotoViewController: UIViewController {
    
    @IBOutlet weak var activityPhoto: UIImageView!
    
    var photo : Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityPhoto.image = photo?.image
    }
}
