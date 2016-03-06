//
//  TripSearchController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 28/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TripSearchController : UITableViewController {
    
    var tripSearchDelegate:TripSearchDelegate?

    private var tripsFound:[Trip] = [] {
        didSet {
            tableView.reloadData()
        }
    }
 
    private struct Constants {
        static let ReuseIdentifierCell = "reuseIdentifierCell"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripsFound.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifierCell)!
        let trip = tripsFound[indexPath.row]
        cell.textLabel?.text = trip.title
        cell.detailTextLabel?.text = trip.tripPeriod
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedTrip = tripsFound[indexPath.row]
        tripSearchDelegate?.tripFound(selectedTrip)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating
extension TripSearchController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {
            return
        }

        let fetchRequest = NSFetchRequest(entityName: Trip.entityName())
        fetchRequest.relationshipKeyPathsForPrefetching = ["inActivity", "inActivity.trip"]
        fetchRequest.predicate = NSPredicate(format:"title BEGINSWITH[c] %@", searchBarText)
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let trips = asynchronousFetchResult.finalResult {
                    self.tripsFound = trips as! [Trip]
                }
            })
        }
        
        do {
            try managedObjectContext.executeRequest(asynchronousFetchRequest)
        } catch let error as NSError {
           print("Could not search trips \(error)")
        }
    }
}