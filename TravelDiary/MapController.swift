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
        static let SearchBarPlaceholder = "Search for locations, activities or trips"
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
                let imageView = UIImageView()
                view.detailCalloutAccessoryView = imageView
            }
            view.pinTintColor = annotation.isStartLocation ? UIColor.greenColor() : UIColor.redColor()
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationAnnotation {
            let location = annotation.location
            if let randomPhoto = location.photos?.anyObject() as? Photo {
                let image = randomPhoto.thumbnail
                let imageView = view.detailCalloutAccessoryView as! UIImageView
                imageView.image = image
                annotation.isSelectedLocation = true
            }
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationAnnotation {
            annotation.isSelectedLocation = false
        }
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        views.forEach { view in
            if let annotation = view.annotation as? LocationAnnotation {
                if annotation.isSelectedLocation {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
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
    
    func locationSelected(selectedLocation: Location) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        let trip = selectedLocation.inActivity!.trip!;
        let activities: [Activity] = trip.activities?.allObjects as! [Activity]
        let annotations = activities
            .filter { activity in
                activity.location?.latitude != nil && activity.location?.longitude != nil}
            .sort { (activity1, activity2) in
                let date1 = activity1.date ?? NSDate.distantPast()
                let date2 = activity2.date ?? NSDate.distantPast()
                let title1 = activity1.title ?? ""
                let title2 = activity2.title ?? ""
                let comparisionDates = date1.compare(date2)
                if comparisionDates == .OrderedSame {
                    return title1.compare(title2) == .OrderedAscending
                } else {
                    return comparisionDates == .OrderedAscending
                }
            }
            .flatMap {activity in activity.location}
            .map {location -> LocationAnnotation in
                let annotation = LocationAnnotation(location: location)
                annotation.isSelectedLocation = location === selectedLocation
                return annotation}
        if let firstAnnotation = annotations.first {
            firstAnnotation.isStartLocation = true
        }

        var coordinates = annotations.flatMap {annotation in annotation.coordinate}
        if annotations.count >= 2 {
            let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: annotations.count)
            mapView.addOverlay(geodesicPolyline)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
}
