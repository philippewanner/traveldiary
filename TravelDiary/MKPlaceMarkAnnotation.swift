//
//  LocationAnnotation.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 09/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import MapKit


class MKPlaceMarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(placemark: MKPlacemark) {
        title = placemark.name
        subtitle = placemark.formattedAddressLines()
        coordinate = placemark.coordinate
    }
}