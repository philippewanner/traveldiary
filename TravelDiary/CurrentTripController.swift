//
//  CurrentTripController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 08/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class CurrentTripController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: Activity.entityName())
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "ActivityTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "reuseCell")
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ActivityCell = self.tableView.dequeueReusableCellWithIdentifier("reuseCell") as! ActivityCell
        let actitvity = fetchedResultsController.objectAtIndexPath(indexPath) as! Activity
        cell.activityDescription.text = actitvity.descr
        cell.activityDate.text = "not yet done"
        return cell
    }
}

