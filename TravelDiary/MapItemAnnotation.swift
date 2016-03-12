//
//  LocationAnnotation.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 09/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import MapKit


class MapItemAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(mapItem: MKMapItem) {
        title = mapItem.name
        subtitle = mapItem.placemark.formattedAddressLines()
        coordinate = mapItem.placemark.coordinate
    }
}