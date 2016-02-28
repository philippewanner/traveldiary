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
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    let dateFormatter = NSDateFormatter()
    let SegueActivityDetailController = "showActivitySegue"
    let addActivitySegue = "addActivitySegue"
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var currentTrip : Trip?
    
    func initializeFetchedResultsController(){
        
        if currentTrip == nil{
            loadCurrenTrip()
        }
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: Activity.entityName())
        fetchRequest.predicate = NSPredicate(format: "ANY trip == %@", currentTrip!)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "ActivityTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "reuseCell")
        dateFormatter.locale = NSLocale(localeIdentifier: "de_CH")
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        initializeFetchedResultsController()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func loadCurrenTrip(){
        let request = NSFetchRequest(entityName: Trip.entityName())
        request.returnsObjectsAsFaults = false;
        //TODO search for current trip 1. CurrentDate within trip range 2. future 3. last
        request.predicate = NSPredicate(format:"title CONTAINS 'ExampleTrip' ")
        var results:NSArray
        do{
            results = try managedObjectContext.executeFetchRequest(request)
            currentTrip = results[0] as? Trip
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
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
        //cell.activityDate.text = dateFormatter.stringFromDate((actitvity.date)!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Perform Segue
        performSegueWithIdentifier(SegueActivityDetailController, sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueActivityDetailController {
            if let destination = segue.destinationViewController as? ActivityDetailController {
               destination.selectedActivity = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as? Activity
            }
        }
    }
    
    @IBAction func unwindSegueAddActivity(segue:UIStoryboardSegue) {}
    
    @IBAction func unwindSequeSaveActiviy(segue: UIStoryboardSegue){
        if let detailController = segue.sourceViewController as? ActivityDetailController {
            let activityToSave = detailController.selectedActivity
            currentTrip?.addActitiesObject(activityToSave!)
            saveFetchReload()
        }
    }
    func saveFetchReload(){
        do {
            try managedObjectContext.save()
            try fetchedResultsController.performFetch()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}

