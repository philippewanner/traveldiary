//
//  ActivityTableViewCell.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 20/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityDate: UILabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
