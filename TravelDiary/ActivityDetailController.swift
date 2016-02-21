//
//  CurrentTripDetailController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 21/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class ActivityDetailController: UIViewController {
    
    var selectedActivity: Activity?
    
    @IBOutlet weak var descr: UITextField!
    
    @IBOutlet weak var activityDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descr.text = selectedActivity?.descr
        activityDate.text = "blub"
    }
}
