//
//  ActivityLocationController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ActivityLocationController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var existingLocation: Location?
    var selectedOnMap: MKMapItem? {
        didSet {
            if let selectedOnMap = selectedOnMap {
                showAnnotation(MapItemAnnotation(mapItem: selectedOnMap))
            }
        }
    }
    
    private let locationManager = CLLocationManager()

    private struct Constants {
        static let SequeEmbedLocationTable = "EmbedLocationTable"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocationAuthorization(self)
        
        let trackingBarButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItems?.append(trackingBarButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showLocation(existingLocation)
    }
    
    func showLocation(location: Location?) {
        if let location = location {
            mapView.removeAnnotations(mapView.annotations)
            if location.coordinate != nil {
                let annotation = LocationAnnotation(location: location)
                showAnnotation(annotation)
            }
        }
    }
    
    func showAnnotation(annotation: MKAnnotation) {
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == Constants.SequeEmbedLocationTable) {
            let tableController = segue.destinationViewController as! ActivityLocationTableController
            tableController.delegate = self
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - LocationSearchDelegate
extension ActivityLocationController: LocationSearchDelegate {
    
    func locationSelected(mapItem: MKMapItem) {
        selectedOnMap = mapItem;
    }
    
}

