import UIKit
import CoreData

class TripsTableViewController : UITableViewController{
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    private struct Constants {
        static let tripTableViewCellNibName = "TripTableViewCell"
        static let cellReuseIdentifier = "reuseTripTableViewCell"
        static let showCurrentTripSegue = "showCurrentTripSegue"
        static let addNewTripSegue = "addNewTripSegue"
        static let editTripSegue = "editTripSegue"
        static let localeIdentifier = "de_CH"
        static let sortKey = "startDate"
        static let sortAscending = true
    }
    
    private let dateFormatter = NSDateFormatter()
    private var fetchedResultsController:NSFetchedResultsController!
    private var currentTrip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.rightBarButtonItem = self.editButtonItem()
        
        self.registerNibFile(Constants.tripTableViewCellNibName)
        
        self.initializeTableViewColor()
        self.initializeDateFormatter()
        self.initializeFetchedResultsController()
        
        self.performFetchData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tripCell: TripTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.cellReuseIdentifier) as! TripTableViewCell
        self.currentTrip = fetchedResultsController.objectAtIndexPath(indexPath) as! Trip
        
        tripCell.tripTitle.text = getTripTitle(self.currentTrip)
        tripCell.tripPeriod.text = getTripPeriod(self.currentTrip)
        
        return tripCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.showCurrentTripSegue {
            if let currentTripController = segue.destinationViewController as? CurrentTripController {
                currentTripController.currentTrip = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as? Trip
            }
        } else if segue.identifier == Constants.editTripSegue {
            if let tripEditController = segue.destinationViewController as? TripEditViewController {
                tripEditController.selectedTrip = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as? Trip
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.showCurrentTripSegue, sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfObjects: Int = 0
        
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            numberOfObjects = currentSection.numberOfObjects
        }
        
        NSLog("number of objects at section \(section): \(numberOfObjects)")
        return numberOfObjects
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let tripToDelete = fetchedResultsController.objectAtIndexPath(indexPath) as! Trip
            NSLog("deleting trip '\(tripToDelete.title!)' at row \(indexPath.row)")
            self.managedObjectContext.deleteObject(tripToDelete)
            self.performSavingData()
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections: Int = 0
        numberOfSections = fetchedResultsController.sections?.count ?? 0
        NSLog("number of sections in table view: \(numberOfSections)")
        return numberOfSections
    }
    
    // segue which is called when the cancel button on the TripEditViewController is called
    @IBAction func unwindSegueAddActivity(segue:UIStoryboardSegue) {
        NSLog("canceled 'adding new trip'")
    }
    
    // segue which is called when the save button on the TripEditViewController is pressed
    @IBAction func unwindSequeSaveActiviy(segue: UIStoryboardSegue){
        self.performSavingData()
    }
    
    private func performSavingData(){
        saveContext()
        NSLog("saving data performed")
    }
    
    private func getTripTitle(trip:Trip) -> String {
        var tripTitle = ""
        if let title = trip.title {
            tripTitle = title
        }
        NSLog("trip title set: " + tripTitle)
        
        return tripTitle
    }
    
    private func getTripPeriod(trip: Trip) -> String{
        var tripPeriod = ""
        if let startDate = trip.startDate {
            tripPeriod = dateFormatter.stringFromDate((startDate))
        }else{
            dateFormatter.stringFromDate((NSDate()))
        }
        if let endDate = trip.endDate {
            tripPeriod += " - " + dateFormatter.stringFromDate((endDate))
        }
        NSLog("trip period set: " + tripPeriod)
        return tripPeriod
    }
    
    private func initializeTableViewColor() {
        tableView.separatorColor = UIColor.clearColor()
    }
    
    private func initializeDateFormatter() {
        dateFormatter.locale = NSLocale(localeIdentifier: Constants.localeIdentifier)
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    private func performFetchData() {
        do {
            try fetchedResultsController.performFetch()
            NSLog("data fetching successfully accomplished")
        } catch {
            let fetchError = error as NSError
            NSLog("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    private func registerNibFile(nibName: String){
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        NSLog("nib file registered: " + Constants.tripTableViewCellNibName)
    }
    
    private func initializeFetchedResultsController(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: Trip.entityName())
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: Constants.sortKey, ascending: Constants.sortAscending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TripsTableViewController: NSFetchedResultsControllerDelegate{

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
            NSLog("deleting row \(indexPath!.row)")
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}