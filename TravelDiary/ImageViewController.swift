//
//  ImageViewController.swift
//  PhotoGallery
//
//  Created by Philippe Wanner on 02/03/16.
//  Copyright © 2016 Philippe Wanner. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.imageView.image = self.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShareButton(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Share photo", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
}
