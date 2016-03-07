//
//  PhotoBuilder.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//


import UIKit
import CoreData;

class PhotoBuilder: BaseBuilder{
    
    private var createDate = NSDate()
    private var imageData = NSData()
    private var title: String?
    private var inActivity: Activity?
    private var location: Location?
    private var trip: Trip?
    
    func build() -> Photo {
        let photo = Photo(managedObjectContext: self.managedObjectContext)
        photo.createDate = self.createDate
        photo.imageData = self.imageData
        photo.title = self.title
        photo.inActivity = self.inActivity
        photo.location = self.location
        photo.trip = self.trip
        return photo
    }
    
    func with(trip trip: Trip) -> PhotoBuilder {
        self.trip = trip
        return self
    }
    
    func with(location location: Location) -> PhotoBuilder {
        self.location = location
        return self
    }
    
    func with(inActivity inActivity: Activity) -> PhotoBuilder {
        self.inActivity = inActivity
        return self
    }
    
    func with(title title: String) -> PhotoBuilder {
        self.title = title
        return self
    }
    
    func with(imageData imageData: NSData) -> PhotoBuilder {
        self.imageData = imageData
        return self
    }
    
    func with(createDate createDate: NSDate) -> PhotoBuilder {
        self.createDate = createDate
        return self
    }
}