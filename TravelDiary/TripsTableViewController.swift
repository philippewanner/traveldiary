import UIKit
import CoreData

class TripsTableViewController : UITableViewController, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    private struct Constants {
        static let tripTableViewCellNibName = "TripTableViewCell"
        static let cellReuseIdentifier = "reuseTripTableViewCell"
        static let currentTripControllerSegue = "showCurrentTripSegue"
        static let localeIdentifier = "de_CH"
        static let sortKey = "startDate"
        static let sortAscending = true
    }
    
    private let dateFormatter = NSDateFormatter()
    private var fetchedResultsController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.rightBarButtonItem = self.editButtonItem()
        
        self.registerNibFile(Constants.tripTableViewCellNibName)
        
        self.initializeTableViewColor()
        self.initializeDateFormatter()
        self.initializeFetchedResultsController()
        
        self.fetchTripsData()
    }
    
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tripCell: TripTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.cellReuseIdentifier) as! TripTableViewCell
        let currentTrip = fetchedResultsController.objectAtIndexPath(indexPath) as! Trip
        
        tripCell.tripTitle.text = getTripTitle(currentTrip)
        tripCell.tripPeriod.text = getTripPeriod(currentTrip)
        
        return tripCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.currentTripControllerSegue {
            if let destination = segue.destinationViewController as? CurrentTripController {
                destination.currentTrip = fetchedResultsController.objectAtIndexPath(tableView.indexPathForSelectedRow!) as? Trip
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.currentTripControllerSegue, sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
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
    
    private func fetchTripsData() {
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