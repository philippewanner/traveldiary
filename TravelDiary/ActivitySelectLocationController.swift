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
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLocation: Location?
    
    private let locationManager = CLLocationManager()
    private var searchController:UISearchController?
    
    private struct Constants {
        static let LocationSearchControllerId = "LocationSearchController"
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
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        let trackingBarButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItems?.append(trackingBarButton)
        
        definesPresentationContext = true
        
        locationSearchController.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let location = selectedLocation {
            showLocation(location)
        } else {
            mapView.userTrackingMode = .Follow
        }
    }
    
    func showLocation(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        searchController?.searchBar.text = location.name
        if location.coordinate != nil {
            let annotation = LocationAnnotation(location: location)
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func setLocationFrom(placemark placemark: MKPlacemark) -> Location {
        let location = selectedLocation ?? Location(managedObjectContext: managedObjectContext)
        location.name = placemark.name
        location.coordinate = placemark.coordinate
        location.address = placemark.thoroughfare
        location.countryCode = placemark.countryCode
        return location
    }
}

// MARK: - LocationSearchDelegate
extension ActivitySelectLocationController: LocationSearchDelegate {
    
    func locationFound(mapItem: MKMapItem) {
        let location = setLocationFrom(placemark: mapItem.placemark)
        showLocation(location)
    }
}

