//
//  CurrentTripController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 08/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class CurrentTripController: UITableViewController{
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    let dateFormatter = NSDateFormatter()
    let SegueActivityDetailController = "showActivitySegue"
    let addActivitySegue = "addActivitySegue"
    
    // Controller to load data
    var fetchedResultsController: NSFetchedResultsController!
    // Currently selected trip
    var currentTrip : Trip?
    
    func initializeFetchedResultsController(){
        if currentTrip == nil{
            loadCurrenTrip()
        }
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: Activity.entityName())
        fetchRequest.predicate = NSPredicate(format: "trip == %@", currentTrip!)
        
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
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "ActivityTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "reuseCell")
        tableView.separatorColor = UIColor.clearColor()
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
    
    /*!
        Loads the current trip if not already present to navigation from the trip table.
    */
    func loadCurrenTrip(){
        let request = NSFetchRequest(entityName: Trip.entityName())
        request.returnsObjectsAsFaults = false;
        //TODO search for current trip 1. CurrentDate within trip range 2. future 3. last
        request.predicate = NSPredicate(format:"title CONTAINS 'An Example Trip' ")
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
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ActivityCell = self.tableView.dequeueReusableCellWithIdentifier("reuseCell") as! ActivityCell
        let actitvity = fetchedResultsController.objectAtIndexPath(indexPath) as! Activity
        cell.activityDescription.text = actitvity.descr
        cell.activityDate.text = dateFormatter.stringFromDate((actitvity.date)!)
        cell.activityTitle.text = actitvity.title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
    
    /*!
        Override to support editing the table view.
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let actitvity = fetchedResultsController.objectAtIndexPath(indexPath) as! Activity
            currentTrip?.removeActivity(actitvity)
            saveContext()
        }
    }
    
    /*!
        segue which is called when the cancel button on the ActivityDetailContoller is called
    */
    @IBAction func unwindSegueAddActivity(segue:UIStoryboardSegue) {}
    
    /*!
        segue which is called when the save button on the ActivityDetailContoller is pressed
    */
    @IBAction func unwindSequeSaveActiviy(segue: UIStoryboardSegue){
        if let detailController = segue.sourceViewController as? ActivityDetailController {
            let activityToSave = detailController.selectedActivity
            currentTrip?.addActitiesObject(activityToSave!)
            saveContext()
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension CurrentTripController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject object: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
