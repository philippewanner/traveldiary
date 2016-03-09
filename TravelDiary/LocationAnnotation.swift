//
//  LocationAnnotation.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 09/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    let location: Location
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(location: Location) {
        self.location = location
        title = location.name
        subtitle = location.address
        coordinate = CLLocationCoordinate2DMake(
            CLLocationDegrees(location.latitude!),
            CLLocationDegrees(location.longitude!))
    }
}