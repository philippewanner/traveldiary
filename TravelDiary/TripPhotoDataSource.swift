//
//  TripPhotoDataSource.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 10/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import UIKit

class TripPhotoDataSource: NSObject, UITableViewDataSource {
    
    var categories = ["cat 1", "cat 2", "cat 3", "cat 4", "cat 5", "cat 6"]
    
    var data : [(image:UIImage, title: String)] = []
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //Number of row in the table view cell.
        return categories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of row in the collection view cell.
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tripCell") as! TripPhotosRow
        return cell
    }
}
