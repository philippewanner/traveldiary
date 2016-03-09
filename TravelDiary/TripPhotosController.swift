//
//  PhotosTripsController.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class TripPhotosController: UIViewController, UITableViewDataSource {
    
    var trips = ["Action", "Drama", "Science Fiction", "Kids", "Horror"]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return trips.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return trips[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell") as! TripPhotosRow
        return cell
    }
}
