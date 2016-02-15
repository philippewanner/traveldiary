//
//  MapController.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 14/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//
// http://stackoverflow.com/questions/21912339/ios-mkmapview-showannotationsanimated-with-padding
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let point1:MKPointAnnotation = MKPointAnnotation()
        point1.coordinate = CLLocationCoordinate2DMake(40.283921, 9.831661)
        let point2:MKPointAnnotation = MKPointAnnotation()
        point2.coordinate = CLLocationCoordinate2DMake(47.036512, 12.521782)
        let point3:MKPointAnnotation = MKPointAnnotation()
        point3.coordinate = CLLocationCoordinate2DMake(35.707032, 139.715278)
        
        
        let annotations:[MKAnnotation] = [point1, point2, point3]
        //mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: false)
        //mapView.setVisibleMapRect(mapView.visibleMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
