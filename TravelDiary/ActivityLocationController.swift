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
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    
    var existingLocation: Location?
    var selectedOnMap: MKPlacemark?
    
    private let locationManager = CLLocationManager()

    private struct Constants {
        static let SequeEmbedLocationTable = "EmbedLocationTable"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocationAuthorization(self)
        locationManager.delegate = self
        
        saveButton.enabled = false
        containerView.hidden = true
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
            } else {
                navigationItem.title = location.name
                containerView.hidden = false
            }
        } else {
            locationManager.requestLocation();
            containerView.hidden = false;
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
            dropAnnotationOnMap(coordinates);
        }
    }
    
    func dropAnnotationOnMap(coordinates: CLLocationCoordinate2D) {
        containerView.hidden = true
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude), completionHandler: {(placemarks, error) -> Void in
            guard error == nil else  {
                print("Reverse geocoder failed with error \(error)")
                return
            }
            
            if let placemark = placemarks?.first {
                annotation.title = placemark.name
                annotation.subtitle = placemark.formattedAddressLines()
                let newPlacemark = MKPlacemark(placemark: placemark)
                self.selectedOnMap = newPlacemark
                self.saveButton.enabled = true
                self.showAnnotation(annotation)
            } else {
                annotation.title = "Unknown Place"
                self.showAnnotation(annotation)
            }
        })
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == Constants.SequeEmbedLocationTable) {
            let tableController = segue.destinationViewController as! ActivityLocationTableController
            tableController.delegate = self
            tableController.initialSearchText = existingLocation?.name
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func search(sender: UIBarButtonItem) {
        containerView.hidden = !containerView.hidden
    }
}

// MARK: - LocationSearchDelegate
extension ActivityLocationController: LocationSearchDelegate {
    
    func locationSelected(placemark: MKPlacemark) {
        selectedOnMap = placemark;
        self.saveButton.enabled = true
        self.showAnnotation(MKPlaceMarkAnnotation(placemark: placemark))
    }
}

// MARK: - LocationSearchDelegate
extension ActivityLocationController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            dropAnnotationOnMap(center)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location update failed: \(error)");
    }
}

