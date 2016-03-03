//
//  LocationBuilder.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//


import UIKit
import CoreData;

class LocationBuilder: BaseBuilder{
    
    private var address: String?
    private var countryCode: String?
    private var latitude: NSNumber?
    private var longitude: NSNumber?
    private var name: String?
    private var inActivity: NSManagedObject?
    private var photos: NSSet?
    
    func build() -> Location {
        let location = Location(managedObjectContext: self.managedObjectContext)
        location.address = self.address
        location.countryCode = self.countryCode
        location.latitude = self.latitude
        location.longitude = self.longitude
        location.name = self.name
        location.inActivity = self.inActivity
        location.photos = self.photos
        return location
    }
    
    func with(photos photos: NSSet) -> LocationBuilder {
        self.photos = photos
        return self
    }
    
    func with(inActivity inActivity: NSManagedObject) -> LocationBuilder {
        self.inActivity = inActivity
        return self
    }
    
    func with(name name: String) -> LocationBuilder {
        self.name = name
        return self
    }
    
    func with(longitude longitude: NSNumber) -> LocationBuilder {
        self.longitude = longitude
        return self
    }
    
    func with(latitude latitude: NSNumber) -> LocationBuilder {
        self.latitude = latitude
        return self
    }
    
    func with(countryCode countryCode: String) -> LocationBuilder {
        self.countryCode = countryCode
        return self
    }
    
    func with(address address: String) -> LocationBuilder {
        self.address = address
        return self
    }
    
}