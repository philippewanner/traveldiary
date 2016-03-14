//
//  BlobImage.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 14/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class BlobImage: NSManagedObject {

    var image : UIImage? {
        get {
            if let imgData = self.imageData {
                return UIImage(data: imgData)
            }
            return nil
        }
        set(value) {
            if let value = value {
                self.imageData = UIImageJPEGRepresentation(value, 1)
            }
        }
    }

}
