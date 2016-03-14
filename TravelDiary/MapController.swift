//
//  MapController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 14/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
//  Ideas: 
//  Clustering pins with https://github.com/ribl/FBAnnotationClusteringSwift
//

import UIKit
import MapKit
import CoreData
import ImageIO

class MapController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    private let locationManager = CLLocationManager()
    private var resultSearchController:UISearchController?
 
    private struct Constants {
        static let ReuseIdentifierAnnotation = "identifier_annotation_view"
        static let MapSearchControllerId = "MapSearchController"
        static let CalloutImageFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        static let SearchBarPlaceholder = "Search for trips"
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocationAuthorization(self)
        
        let mapSearchController = storyboard!.instantiateViewControllerWithIdentifier(Constants.MapSearchControllerId) as! MapSearchController
        resultSearchController = UISearchController(searchResultsController: mapSearchController)
        resultSearchController?.searchResultsUpdater = mapSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.SearchBarPlaceholder
        navigationItem.titleView = searchBar
        
        let trackingBarButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = trackingBarButton
        definesPresentationContext = true
        
        mapSearchController.delegate = self
    }
}

// MARK: - MKMapViewDelegate
extension MapController : MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LocationAnnotation {
            let view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.ReuseIdentifierAnnotation)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.ReuseIdentifierAnnotation)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
                let imageView = UIImageView(frame: Constants.CalloutImageFrame)
                view.detailCalloutAccessoryView = imageView

            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationAnnotation {
            let location = annotation.location
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { _ in
                if let randomPhoto = location.photos?.anyObject() {
                    let image = (randomPhoto as! Photo).image
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let imageView = view.detailCalloutAccessoryView as! UIImageView
                        imageView.image = image
                        imageView.frame = Constants.CalloutImageFrame
                    }
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let locationAnnotation = view.annotation as! LocationAnnotation
        print(locationAnnotation.location.inActivity);
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 1.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blueColor()
        
        return renderer
    }
}

// MARK: - TripSearchDelegate
extension MapController: MapSearchDelegate {
    
    func tripFound(trip: Trip) {
        resultSearchController?.searchBar.text = trip.title
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let activities: [Activity] = trip.activities?.allObjects as! [Activity]
        let annotations = activities
            .filter { activity in
                activity.location?.latitude != nil && activity.location?.longitude != nil}
            .sort { (activity1, activity2) in
                let date1 = activity1.date ?? NSDate.distantPast()
                let date2 = activity2.date ?? NSDate.distantPast()
                return date1.compare(date2) == .OrderedAscending
            }
            .flatMap {activity in activity.location}
            .map {location in LocationAnnotation(location: location)}
        
        var coordinates = annotations.flatMap {annotation in annotation.coordinate}
        if annotations.count >= 2 {
            let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: annotations.count)
            mapView.addOverlay(geodesicPolyline)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}
