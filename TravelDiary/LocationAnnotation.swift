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
    
    // optional attributes
    var isStartLocation = false
    var isSelectedLocation = false
    
    init(location: Location) {
        self.location = location
        self.coordinate = location.coordinate!
        title = location.name
        subtitle = location.address
    }
}