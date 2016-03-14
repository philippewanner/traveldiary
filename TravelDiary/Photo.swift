//
//  Photo.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 15/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Photo: NSManagedObject {
    
    @NSManaged var createDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var imageBlob: BlobImage?
    @NSManaged var inActivity: Activity?
    @NSManaged var location: Location?
    @NSManaged var thumbnailBlob: BlobThumbnail?
    @NSManaged var trip: Trip?
    
    var image : UIImage? {
        get {
            return self.imageBlob?.image
        }
        set(value) {
            self.imageBlob?.image = value
        }
    }

    var thumbnail : UIImage? {
        get {
            return self.thumbnailBlob?.thumbnail
        }
        set(value) {
            self.thumbnailBlob?.thumbnail = value
        }
    }
    
    var text : String? {
        get {
            if let value = self.title {
                return value
            }
            return nil
        }
        set(value) {
            if let value = value {
                self.title = value
            }
        }
    }
}
