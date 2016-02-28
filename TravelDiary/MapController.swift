//
//  MapController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 14/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return locationManager
    }()
    
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    private struct Constants {
        static let ReuseIdentifierAnnotation = "identifier_annotation_view"
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        let tracktingBarButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = tracktingBarButton
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self

        loadLocations(
            managedObjectContext,
            success: {locations in
                let annotations = self.convertLocationsToAnnotations(locations)
                self.showAnnotations(annotations)
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
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
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
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationAnnotation {
            let location = annotation.location
            if let randomPhoto = location.photos?.anyObject() {
                
                // TODO: Loads the whole image on the main thread: should be done async (maybe we should also store thumbnails..)
                let imageData = (randomPhoto as! Photo).imageData
                let imageView = UIImageView(image: UIImage(data: imageData))
                imageView.frame = CGRectMake(0, 0, view.frame.size.height, view.frame.size.height)
                imageView.contentMode = .ScaleAspectFit
                view.leftCalloutAccessoryView = imageView
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let locationAnnotation = view.annotation as! LocationAnnotation
        print(locationAnnotation.location.inActivity);
        self.tabBarController?.selectedIndex = 1
    }
    
    func mapViewWillStartLocatingUser(mapView: MKMapView) {
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

extension MapController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.title
        annotation.subtitle = placemark.name
        let annotations = [annotation]
        mapView.showAnnotations(annotations, animated: true)
    }
}
