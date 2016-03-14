//
//  BlobThumbnail.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 14/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class BlobThumbnail: NSManagedObject {
    
    @NSManaged private var thumbnailData: NSData?
    @NSManaged private var photo: Photo?

    var thumbnail : UIImage? {
        get {
            if let thumbData = self.thumbnailData {
                return UIImage(data: thumbData)
            }
            return nil
        }
        set(value) {
            if let value = value {
                self.thumbnailData = UIImageJPEGRepresentation(value, 1)
            }
        }
    }

}
