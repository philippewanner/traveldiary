//
//  SelectLocationController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
// http://stackoverflow.com/questions/30858360/adding-a-pin-annotation-to-a-map-view-on-a-long-press-in-swift
// http://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/

import Foundation
import UIKit
import MapKit

class ActivitySelectLocationController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    var selectedMapItem: MKMapItem?
    
    private let locationManager = CLLocationManager()
    private var searchController:UISearchController?
    
    private struct Constants {
        static let LocationSearchControllerId = "LocationSearchController"
        static let CalloutImageFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        static let SearchBarPlaceholder = "Search for places"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocationAuthorization(self)
        
        let locationSearchController = storyboard!.instantiateViewControllerWithIdentifier(Constants.LocationSearchControllerId) as! LocationSearchController
        searchController = UISearchController(searchResultsController: locationSearchController)
        searchController?.searchResultsUpdater = locationSearchController
        searchController?.hidesNavigationBarDuringPresentation = false
        
        let searchBar = searchController!.searchBar
        searchBar.placeholder = Constants.SearchBarPlaceholder
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        definesPresentationContext = true
        
        locationSearchController.delegate = self
    }
}

// MARK: - LocationSearchDelegate
extension ActivitySelectLocationController: LocationSearchDelegate {
    
    func locationFound(mapItem: MKMapItem) {
        searchController?.searchBar.text = mapItem.name
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.placemark.name
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        selectedMapItem = mapItem
    }
}

// MARK: - MKMapViewDelegate
extension ActivitySelectLocationController: MKMapViewDelegate {
    

}
