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
    @IBOutlet weak var toolbar: UIToolbar!
    
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
        locationManager.delegate = self
        
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
            locationManager.requestLocation()
        }
    }
    
    func showLocation(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        searchController?.searchBar.text = location.name
        if location.hasCoordinates() {
            let annotation = LocationAnnotation(location: location)
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func setLocationFrom(placemark placemark: MKPlacemark) -> Location {
        let location = selectedLocation ?? Location(managedObjectContext: managedObjectContext)
        location.name = placemark.name
        location.latitude = placemark.coordinate.latitude
        location.longitude = placemark.coordinate.longitude
        location.address = placemark.thoroughfare
        location.countryCode = placemark.countryCode
        return location
    }
}

// MARK: - LocationSearchDelegate
extension ActivitySelectLocationController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) -> Void in
                if let error = error {
                    print("Reverse geocoder failed with error" + error.localizedDescription)
                    return
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        self.setLocationFrom(placemark: MKPlacemark(placemark: placemark))
                    } else {
                        print("Problem with the data received from geocoder")
                    }
                }
        })
        }
    }
}

// MARK: - LocationSearchDelegate
extension ActivitySelectLocationController: LocationSearchDelegate {
    
    func locationFound(mapItem: MKMapItem) {
        let location = setLocationFrom(placemark: mapItem.placemark)
        showLocation(location)
    }
}

