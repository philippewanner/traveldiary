//
//
//

import UIKit
import CoreData

class TripsTableViewController : UITableViewController{
    
    private var _fetchedResultsController:NSFetchedResultsController!
    private var fetchedResultsController:NSFetchedResultsController!{
        if _fetchedResultsController != nil { return _fetchedResultsController }
        
        let request = NSFetchRequest(entityName: Trip.entityName())
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try _fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        return _fetchedResultsController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((fetchedResultsController.sections?[section])! as NSFetchedResultsSectionInfo).numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseCell", forIndexPath: indexPath) as! TripTableViewCell
        
        cell.trip = fetchedResultsController.objectAtIndexPath(indexPath) as! Trip
        
        return cell
    }
}