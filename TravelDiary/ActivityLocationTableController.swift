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

class ActivityLocationTableController : UITableViewController {
    
    var delegate: LocationSearchDelegate?
    var searchController: UISearchController!
    var search: MKLocalSearch?
    var initialSearchText: String?

    var placemarks:[MKPlacemark] = [] {
        didSet {
            tableView.reloadData()
        }
    }
 
    private struct Constants {
        static let ReuseIdentifierCell = "reuseIdentifierCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        let searchBar = searchController!.searchBar
        searchBar.sizeToFit()
        searchBar.text = initialSearchText
        tableView.tableHeaderView = searchBar
        definesPresentationContext = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placemarks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifierCell)!
        let placemark = placemarks[indexPath.row]
        cell.textLabel?.text = placemark.name
        cell.detailTextLabel?.text = placemark.formattedAddressLines()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let placemark = placemarks[indexPath.row]
        delegate?.locationSelected(placemark)
    }
}

// MARK: - UISearchResultsUpdating
extension ActivityLocationTableController : UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        search?.cancel()
        search = MKLocalSearch(request: request)
        search?.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            self.placemarks = response.mapItems.map{ item in item.placemark}
        }
    }
}
