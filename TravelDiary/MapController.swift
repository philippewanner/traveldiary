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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        loadLocations(
            managedObjectContext,
            success: {locations in
                let annotations = self.convertLocationsToMKPointAnnotations(locations)
                self.showAnnotations(annotations)
            },
            failed: {error in
                print("Could not save \(error)")
            }
        )
    }
    
    func loadLocations(managedObjectContext: NSManagedObjectContext, success: ([Location]) -> Void, failed: (NSError) -> Void) {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.parentContext = managedObjectContext
        privateContext.performBlock {
            let request = NSFetchRequest(entityName: Location.entityName())
            request.predicate = NSPredicate(format:"longitude != nil AND latitude != nil")
            do {
                let locations: [Location] = try managedObjectContext.executeFetchRequest(request) as! [Location]
                success(locations)
            } catch let error as NSError {
                failed(error)
            }
        }
    }
    
    func convertLocationsToMKPointAnnotations(locations: [Location]) -> [MKPointAnnotation]{
        return locations.map({location in
            let point: MKPointAnnotation = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2DMake(
                CLLocationDegrees(location.latitude!),
                CLLocationDegrees(location.longitude!))
            return point
        })
    }
    
    func showAnnotations(annotations: [MKPointAnnotation]){
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: false)
    }
    
    enum CoreDataError: ErrorType {
        case FetchError
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
