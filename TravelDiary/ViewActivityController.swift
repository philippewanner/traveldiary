//
//  ViewActivityController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 14/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class ViewActivityController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedActivity: Activity!
    
    private struct Constants{
        static let EditActivitySegue = "EditActivitySeque"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = selectedActivity.title
        if selectedActivity.dateAsString != nil {
            subtitleLabel.text = selectedActivity.dateAsString
        } else {
            subtitleLabel.hidden = true
        }
        
        if let descr = selectedActivity.descr {
            textView.text = descr
        } else {
            textView.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.EditActivitySegue {
            let navController = segue.destinationViewController as! UINavigationController
            let activityDetailController = navController.topViewController as!ActivityDetailController
            activityDetailController.addMode = false
            activityDetailController.selectedActivity = selectedActivity
        }
    }
}
