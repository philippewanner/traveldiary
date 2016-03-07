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
            if let imageData = imageData {
                return UIImage(data: imageData)
            }
            return nil
        }
        set(value) {
            if let value = value {
                imageData = UIImageJPEGRepresentation(value, 1)
            }
        }
    }
    
    var text : String? {
        get {
            if let value = title {
                return value
            }
            return nil
        }
        set(value) {
            if let value = value {
                title = value
            }
        }
    }
}
