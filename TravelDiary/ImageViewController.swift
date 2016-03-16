//
//  ImageViewController.swift
//  PhotoGallery
//
//  Created by Philippe Wanner on 02/03/16.
//  Copyright © 2016 Philippe Wanner. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = photo.title
        self.imageView.image = self.photo.image
        self.imageView.userInteractionEnabled = true
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 8.0
        let shareBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "onShareButton")
        let deleteBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "onDeleteButton")
        navigationItem.rightBarButtonItems = [shareBtn, deleteBtn]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "toggleNavigationBar")
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        self.imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onShareButton() {
        let activityController = UIActivityViewController(activityItems: ["Share photo", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func onDeleteButton() {
        managedObjectContext.deleteObject(self.photo)
        imageView.opaque = true
        imageView.alpha = 0.6
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func toggleNavigationBar() {
        if navigationController?.navigationBar.hidden == false && tabBarController?.tabBar.hidden == false{
            navigationController?.navigationBar.hidden = true
            tabBarController?.tabBar.hidden = true
        }
        else{
            navigationController?.navigationBar.hidden = false
            tabBarController?.tabBar.hidden = false
        }
    }
}
