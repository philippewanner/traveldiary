//
//  ViewActivityController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 14/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class ViewActivityController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var fetchedResultsController: NSFetchedResultsController!
    
    var selectedActivity: Activity!
    var photos: [Photo]!
    
    private struct Constants{
        static let EditActivitySegue = "EditActivitySeque"
        static let ImageReuseIdentifier = "ImageReuseIdentifier"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = selectedActivity.title
        
        subtitleLabel.text = selectedActivity.dateAsString
        subtitleLabel.hidden = subtitleLabel.text == nil
        
        textView.text = selectedActivity.descr
        textView.hidden = textView.text == nil
        
        //collectionView.delegate = self
    }
}

//MARK: - UICollectionViewDataSource - Datasource for the CollectionView which fetches from the FetchedResultController
extension ViewActivityController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.ImageReuseIdentifier, forIndexPath: indexPath) as! ActivityPhotoCell
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        cell.activityPhoto.image = photo.thumbnail
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
}
