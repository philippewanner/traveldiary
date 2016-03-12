//
//  Location.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 15/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Location: NSManagedObject {
    
    var coordinate: CLLocationCoordinate2D? {
        get {
            guard let latitude = latitude, let longitude = longitude else {
                return nil
            }
            return CLLocationCoordinate2DMake(
                CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        }
        
        set {
            latitude = newValue?.latitude
            longitude = newValue?.longitude
        }
    }
}
