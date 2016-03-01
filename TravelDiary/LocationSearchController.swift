//
//  LocationSearchController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 28/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchController : UITableViewController {
    
    var mapSearchDelegate:MapSearchDelegate? = nil
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    
    private struct Constants {
        static let ReuseIdentifierCell = "reuseIdentifierCell"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifierCell)!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = selectedItem.title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        mapSearchDelegate?.placeFound(selectedItem)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LocationSearchController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {
            return
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}