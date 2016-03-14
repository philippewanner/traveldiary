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
    
    private let maxThumbnailSize: CGSize = CGSize(width: 200, height: 200)

    var thumbnail : UIImage? {
        get {
            if let thumbData = self.thumbnailData {
                return UIImage(data: thumbData)
            }
            return nil
        }
        set(value) {
            if let value = value {
                var thumbResized: UIImage
                if(value.size.width > maxThumbnailSize.width){
                    NSLog("resize")
                    thumbResized = resizeImage(value, width: maxThumbnailSize.width)
                } else {
                    NSLog("no resizing")
                    thumbResized = value
                }
                self.thumbnailData = UIImageJPEGRepresentation(thumbResized, 1)
            }
        }
    }
    
    private func resizeImage(imageToResize: UIImage, width: CGFloat) -> UIImage
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
