//
//  
//

import UIKit

class TripTableViewCell: UITableViewCell{

    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var tripDate: UILabel!
    
    
    var trip:Trip!{
        didSet{
            tripTitle.text = trip.title
            tripDate.text = trip.startDate?.description
        }
    }
}