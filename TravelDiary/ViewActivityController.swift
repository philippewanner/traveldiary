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
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedActivity: Activity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedActivity = selectedActivity {
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
    }
}
