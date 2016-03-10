//
//  TripPhotosController.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 09/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class TripPhotosController: UITableViewController {
    
    var categories = ["cat 1", "cat 2", "cat 3", "cat 4", "cat 5", "cat 6"]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //Number of row in the table view cell.
        return categories.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Number of row in the collection view cell.
        return 1
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tripCell") as! TripPhotosRow
        return cell
    }
}
