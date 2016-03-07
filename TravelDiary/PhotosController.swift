//
//  ViewController.swift
//  PhotoGallery
//
//  Created by Philippe Wanner on 02/03/16.
//  Copyright © 2016 Philippe Wanner. All rights reserved.
//

import UIKit
import CoreData

class PhotosController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tripsPhotosView: UIView!
    @IBOutlet weak var allPhotosView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsPhotosView.hidden = true
        allPhotosView.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func photosViewChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            allPhotosView.hidden = false
            tripsPhotosView.hidden = true
        case 1:
            allPhotosView.hidden = true
            tripsPhotosView.hidden = false
        default:
            break;
        }
    }
    
}

