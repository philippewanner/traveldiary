//
//  MapController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 14/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
//     // TODO: Was ist mit starken Referenzen? Könnte es ein Memory Leak geben?
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
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    private struct Constants {
        static let ReuseIdentifierAnnotation = "identifier_annotation_view"
        //static let ShowActivitySeque = "Show Photos"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
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
}

extension MapController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        //mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension MapController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("locationManager error:: \(error)")
    }
}
