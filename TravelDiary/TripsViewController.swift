//
//  TripsController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 08/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class TripsViewController: UIViewController{

    @IBOutlet weak var trips: UITableView!
    @IBOutlet var tripsTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tripTableViewCellNib = UINib(nibName: "TripTableViewCell", bundle: nil)
        trips.registerNib(tripTableViewCellNib, forCellReuseIdentifier: "reuseCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}