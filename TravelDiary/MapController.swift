//
//  MapController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 14/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
// http://stackoverflow.com/questions/21912339/ios-mkmapview-showannotationsanimated-with-padding
//     // TODO: Was ist mit starken Referenzen? Könnte es ein Memory Leak geben?
//

import UIKit
import MapKit
import CoreData

class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    let ReuseIdentifierAnnotation = "identifier_annotation_view"
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LocationAnnotation {
            let view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(ReuseIdentifierAnnotation)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: ReuseIdentifierAnnotation)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let annotation = view.annotation as? LocationAnnotation {
            if let randomPhoto = annotation.location.photos?.allObjects[0] {
                randomPhoto
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let locationAnnotation = view.annotation as! LocationAnnotation
        print(locationAnnotation.location.inActivity);
        // TODO: Switch tab and show activity
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
