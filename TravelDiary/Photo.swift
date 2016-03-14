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
