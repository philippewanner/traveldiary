//
//  Photo-UIImage.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import UIKit

extension Photo {

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
}
