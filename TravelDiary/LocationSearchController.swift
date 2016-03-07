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

class LocationSearchController : UITableViewController {
    
    var delegate: LocationSearchDelegate?

    private var mapItemsFound:[MKMapItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
 
    private struct Constants {
        static let ReuseIdentifierCell = "reuseIdentifierCell"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItemsFound.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifierCell)!
        let mapItem = mapItemsFound[indexPath.row]
        cell.textLabel?.text = mapItem.name
        //cell.detailTextLabel?.text = mapItem.
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMapItem = mapItemsFound[indexPath.row]
        delegate?.locationFound(selectedMapItem)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating
extension LocationSearchController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.mapItemsFound = response.mapItems
        }
    }
}