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

class SelectLocationController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    private let locationManager = CLLocationManager()
    private var resultSearchController:UISearchController?
    
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
        resultSearchController = UISearchController(searchResultsController: locationSearchController)
        resultSearchController?.searchResultsUpdater = locationSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.SearchBarPlaceholder
        navigationItem.titleView = searchBar
        
        definesPresentationContext = true
        
        locationSearchController.delegate = self
    }
}

// MARK: - LocationSearchDelegate
extension SelectLocationController: LocationSearchDelegate {
    
    func locationFound(mapItem: MKMapItem) {
        resultSearchController?.searchBar.text = mapItem.name
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.placemark.name
        mapView.addAnnotation(annotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension SelectLocationController: MKMapViewDelegate {
    

}
