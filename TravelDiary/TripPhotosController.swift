//
//  TripPhotosController.swift
//  TravelDiary
//
//  Created by Philippe Wanner on 09/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class TripPhotosController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
//    var categories = ["cat 1", "cat 2", "cat 3", "cat 4", "cat 5", "cat 6"]
    
    // Data Source for UITableView
    var tripPhotosDataSource = TripPhotoDataSource()
    
    // Core Data managed context
    var managedContext : NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("wiewDidLoad")
        // setup Core Data context
        coreDataSetup()
        // load photos in memory
        loadPhotos()
        // Attached the data source to the collection view
        tableView.dataSource = tripPhotosDataSource
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPhotos(){
        
        NSLog("loadPhotos")
        // loadCoreDataImages fct with a completion block
        loadCoreDataImages { (images) -> Void in
            NSLog("loadCoreDataImages in")
            if let images = images {
                
                self.tripPhotosDataSource.data += images.map { return (image:$0.image ?? UIImage(),title:$0.title ?? "") }
                
                NSLog("start dataSource:%d", self.tripPhotosDataSource.data.count)
                
            } else {
                self.noImagesFound()
            }
        }
    }
}
