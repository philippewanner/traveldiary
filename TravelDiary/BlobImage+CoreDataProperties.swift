////
////  BlobImage+CoreDataProperties.swift
////  TravelDiary
////
////  Created by Philippe Wanner on 14/03/16.
////  Copyright © 2016 PTPA. All rights reserved.
////
////  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
////  to delete and recreate this implementation file for your updated model.
////
//
//import Foundation
//import CoreData
//
//extension BlobImage {
//
//    @NSManaged private var imageData: NSData?
//    @NSManaged private var photo: Photo?
//    
//    var image: UIImage? {
//        get {
//            if let imgData = self.imageData {
//                return UIImage(data: imgData)
//            }
//            return nil
//        }
//        set(value) {
//            if let value = value {
//                self.imageData = UIImageJPEGRepresentation(value, 1)
//            }
//        }
//    }
//}
