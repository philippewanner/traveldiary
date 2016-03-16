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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rootStackView: UIStackView!
    
    var selectedActivity: Activity!
    
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
        
        textView.textContainer.lineFragmentPadding = 0;
        
        let photos = selectedActivity.photos?.allObjects as! [Photo]
        photos.forEach { photo in
            let image = photo.image
            let imgView = UIImageView(image: image)
            imgView.sizeToFit()
            rootStackView.addArrangedSubview(imgView)
        }
    }
}

