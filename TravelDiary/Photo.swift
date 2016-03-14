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
            if let imageData = self.imageBlob?.imageData {
                return UIImage(data: imageData)
            }
            return nil
        }
        set(value) {
            if let value = value {
                self.imageBlob?.imageData = UIImageJPEGRepresentation(value, 1)
            }
        }
    }

    var thumbnail : UIImage? {
        get {
            if let thumbnailData = self.thumbnailBlob?.thumbnailData {
                return UIImage(data: thumbnailData)
            }
            return nil
        }
        set(value) {
            if let value = value {
                let image = resizeImage(value, width: 200)
                self.thumbnailBlob?.thumbnailData = UIImageJPEGRepresentation(image, 1)
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
    
    func resizeImage(imageToResize: UIImage, width: CGFloat) -> UIImage
    {
        let scale = width / imageToResize.size.width
        let height = imageToResize.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        imageToResize.drawInRect(CGRectMake(0, 0, width, height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    

}
