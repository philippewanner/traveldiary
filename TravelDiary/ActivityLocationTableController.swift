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

    private var mapItemsFound:[MKMapItem] = [] {
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
        
        let searchBar = searchController!.searchBar
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        definesPresentationContext = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItemsFound.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ReuseIdentifierCell)!
        let mapItem = mapItemsFound[indexPath.row]
        cell.textLabel?.text = mapItem.name
        cell.detailTextLabel?.text = mapItem.placemark.formattedAddressLines()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMapItem = mapItemsFound[indexPath.row]
        delegate?.locationSelected(selectedMapItem)
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
            self.mapItemsFound = response.mapItems
        }
    }
}