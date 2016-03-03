import UIKit
import CoreData

class TripsTableViewController : UITableViewController, NSFetchedResultsControllerDelegate{
    
    private let tripTableViewCellNibName = "TripTableViewCell"
    private let cellReuseIdentifier = "reuseCell"
    private let localeIdentifier = "de_CH"
    private let sortKey = "startDate"
    private let sortAscending = true
    private let dateFormatter = NSDateFormatter()
    
    private var fetchedResultsController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibFile(tripTableViewCellNibName)
        
        self.initializeTableViewColor()
        self.initializeDateFormatter()
        self.initializeFetchedResultsController()
        
        self.fetchTripsData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tripCell: TripTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! TripTableViewCell
        let currentTrip = fetchedResultsController.objectAtIndexPath(indexPath) as! Trip
        
        tripCell.tripTitle.text = currentTrip.title
        print("trip title set: \(currentTrip.title)")
        
        tripCell.tripDate.text = getTripPeriod(currentTrip)
        
        return tripCell
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
        print("trip period set: " + tripPeriod)
        return tripPeriod
    }
    
    private func initializeTableViewColor() {
        tableView.separatorColor = UIColor.clearColor()
    }
    
    private func initializeDateFormatter() {
        dateFormatter.locale = NSLocale(localeIdentifier: localeIdentifier)
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
    }
    
    private func fetchTripsData() {
        do {
            try fetchedResultsController.performFetch()
            print("data fetching successfully accomplished")
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    private func registerNibFile(nibName: String){
        let nib = UINib(nibName: nibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    private func initializeFetchedResultsController(){
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: Trip.entityName())
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: sortAscending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
    }
}