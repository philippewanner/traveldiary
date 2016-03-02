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
//  Connect locations with http://nshipster.com/mkgeodesicpolyline/
//

import UIKit
import MapKit
import CoreData

protocol MapSearchDelegate {
    func placeFound(placemark:MKPlacemark)
}

class MapController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    let locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    private struct Constants {
        static let ReuseIdentifierAnnotation = "identifier_annotation_view"
        static let SearchBarPlaceHolder = "Search for places"
        static let LocationSearchControllerId = "LocationSearchController"
        static let CalloutImageFrame = CGRectMake(0, 0, 50, 50)
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        requestLocationAuthorization()
        
        let locationSearchController = storyboard!.instantiateViewControllerWithIdentifier(Constants.LocationSearchControllerId) as! LocationSearchController
        resultSearchController = UISearchController(searchResultsController: locationSearchController)
        resultSearchController?.searchResultsUpdater = locationSearchController
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.SearchBarPlaceHolder
        navigationItem.titleView = resultSearchController?.searchBar
        
        let tracktingBarButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = tracktingBarButton
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchController.mapView = mapView
        locationSearchController.mapSearchDelegate = self

        loadLocations(
            managedObjectContext,
            success: {locations in
                let annotations = self.convertLocationsToAnnotations(locations)
                self.showAnnotations(annotations)
                var coordinates = annotations.map {annotation in annotation.coordinate}
                let geodesicPolyline = MKGeodesicPolyline(coordinates: &coordinates, count: annotations.count)
                self.mapView.addOverlay(geodesicPolyline)
            },
            failed: {error in
                print("Could not fetch locations \(error)")
            }
        )
    }
    
    func loadLocations(managedObjectContext: NSManagedObjectContext, success: ([Location]) -> Void, failed: (NSError) -> Void) {
        let fetchRequest = NSFetchRequest(entityName: Location.entityName())
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
    
    func convertLocationsToAnnotations(locations: [Location]) -> [MKAnnotation]{
        return locations.map {location in
            LocationAnnotation(location: location)
        }
    }
    
    func showAnnotations(annotations: [MKAnnotation]){
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func requestLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        if (status == .NotDetermined) {
            locationManager.requestWhenInUseAuthorization()
        } else if (status == .Denied) {
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to display your current location, please open this app's settings and allow access to location.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

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
                        imageView.image = UIImage(data: imageData)
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

extension MapController: MapSearchDelegate {
    func placeFound(placemark: MKPlacemark) {
        selectedPin = placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.title
        annotation.subtitle = placemark.name
        let annotations = [annotation]
        mapView.showAnnotations(annotations, animated: true)
    }
}
