//
//
//

import UIKit
import CoreData

class TripsViewController: UIViewController{

    @IBOutlet weak var trips: UITableView!
    @IBOutlet var tripsTitle: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tripTableViewCellNib = UINib(nibName: "TripTableViewCell", bundle: nil)
        trips.registerNib(tripTableViewCellNib, forCellReuseIdentifier: "reuseCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //var destViewController : CurrentTripController = segue.destinationViewController as! CurrentTripController
    }
}