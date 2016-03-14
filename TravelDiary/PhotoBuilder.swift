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
    private var title: String?
    private var inActivity: Activity?
    private var location: Location?
    private var trip: Trip?
    private var thumbnailBlob: BlobThumbnail?
    private var imageBlob : BlobImage?
    
    func build() -> Photo {
        let photo = Photo(managedObjectContext: self.managedObjectContext)
        photo.createDate = self.createDate
        photo.imageBlob = self.imageBlob
        photo.thumbnailBlob = self.thumbnailBlob
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
    
    func with(imageBlob imageBlob: BlobImage) -> PhotoBuilder {
        self.imageBlob = imageBlob
        return self
    }
    
    func with(thumbnailBlob thumbnailBlob: BlobThumbnail) -> PhotoBuilder {
        self.thumbnailBlob = thumbnailBlob
        return self
    }
    
    func with(imageData imageData: NSData) -> PhotoBuilder {
        let imgblob = BlobImage(managedObjectContext: self.managedObjectContext)
        imgblob.image = UIImage(data: imageData)
        let thumbBlob = BlobThumbnail(managedObjectContext: self.managedObjectContext)
        thumbBlob.thumbnail = UIImage(data: imageData)
        self.imageBlob = imgblob
        self.thumbnailBlob = thumbBlob
        return self
    }
    
    func with(thumbnailData thumbnailData: NSData) -> PhotoBuilder {
        let blob = BlobThumbnail(managedObjectContext: self.managedObjectContext)
        blob.thumbnail = UIImage(data: thumbnailData)
        self.thumbnailBlob = blob
        return self
    }
    
    func with(createDate createDate: NSDate) -> PhotoBuilder {
        self.createDate = createDate
        return self
    }
}