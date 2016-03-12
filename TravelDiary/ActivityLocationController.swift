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
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var existingLocation: Location?
    var selectedOnMap: MKMapItem? {
        didSet {
            if let selectedOnMap = selectedOnMap {
                saveButton.enabled = true
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
        saveButton.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showLocation(existingLocation)
    }
    
    func showLocation(location: Location?) {
        if let location = location {
            if location.coordinate != nil {
                let annotation = LocationAnnotation(location: location)
                showAnnotation(annotation)
            }
        } else {
            mapView.showsUserLocation = true
        }
    }
    
    func showAnnotation(annotation: MKAnnotation) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        navigationItem.title = annotation.title!
    }
    
    @IBAction func longPressRecognized(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(mapView)
            let coordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                guard error == nil else  {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if let placemark = placemarks?.first {
                    annotation.title = placemark.name
                    annotation.subtitle = placemark.formattedAddressLines()
                    self.showAnnotation(annotation)
                } else {
                    annotation.title = "Unknown Place"
                    self.showAnnotation(annotation)
                }
            })
        }
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

