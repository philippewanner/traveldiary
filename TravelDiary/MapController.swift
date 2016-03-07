//
//  MapController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 14/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
//  Ideas: 
//  Clustering pins with https://github.com/ribl/FBAnnotationClusteringSwift
//  Take snapshots of location: http://stackoverflow.com/questions/30793315/customize-mkannotation-callout-view
//

import UIKit
import MapKit
import CoreData

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
        static let TripSearchControllerId = "TripSearchController"
        static let CalloutImageFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        static let SearchBarPlaceholder = "Search for trips"
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocationAuthorization(self)
        
        let tripSearchController = storyboard!.instantiateViewControllerWithIdentifier(Constants.TripSearchControllerId) as! TripSearchController
        resultSearchController = UISearchController(searchResultsController: tripSearchController)
        resultSearchController?.searchResultsUpdater = tripSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.SearchBarPlaceholder
        navigationItem.titleView = searchBar
        
        let trackingBarButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = trackingBarButton
        definesPresentationContext = true
        
        tripSearchController.tripSearchDelegate = self

        loadLocations(
            managedObjectContext,
            success: {locations in
                let annotations = locations.map {location in LocationAnnotation(location: location)}
                self.mapView.addAnnotations(annotations)
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            },
            failed: {error in
                print("Could not fetch locations \(error)")
            }
        )
    }
    
    func loadLocations(managedObjectContext: NSManagedObjectContext, success: ([Location]) -> Void, failed: (NSError) -> Void) {
        let fetchRequest = NSFetchRequest(entityName: Location.entityName())
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.relationshipKeyPathsForPrefetching = ["activities", "activities.location"]
        
        fetchRequest.predicate = NSPredicate(format:"longitude != nil AND latitude != nil")
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asynchronousFetchResult) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let locations = asynchronousFetchResult.finalResult{
                    success(locations as! [Location])
                }
            })
        }
        
        do {
            try managedObjectContext.executeRequest(asynchronousFetchRequest)
        } catch let error as NSError {
            failed(error)
        }
    }
}

// MARK: - LocationAnnotation
class LocationAnnotation: NSObject, MKAnnotation {
    let location: Location
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(location: Location) {
        self.location = location
        title = location.name
        coordinate = CLLocationCoordinate2DMake(
            CLLocationDegrees(location.latitude!),
            CLLocationDegrees(location.longitude!))
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
                    let imageData = (randomPhoto as! Photo).imageData
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let imageView = view.detailCalloutAccessoryView as! UIImageView
                        imageView.image = UIImage(data: imageData!)
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
extension MapController: TripSearchDelegate {
    
    func tripFound(trip: Trip) {
        resultSearchController?.searchBar.text = trip.title
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        let activities: [Activity] = trip.activities?.allObjects as! [Activity]
        let locations = activities.flatMap{activity in activity.location}
        let annotations = locations.map {location in LocationAnnotation(location: location)}
        var coordinates = annotations.flatMap {annotation in annotation.coordinate}
        if annotations.count >= 2 {
            let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: annotations.count)
            mapView.addOverlay(geodesicPolyline)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}
