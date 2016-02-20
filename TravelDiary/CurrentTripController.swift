//
//  CurrentTripController.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 08/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit

class CurrentTripController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData:[String] = ["Machu Picchu","Arequipa", "Lima","Titicaca", "Desierto de Atacama", "Pantanal", "Ciudad Perdida" ,"Perito Moreno" , "Torres del Paine", "Cali" ,"Iguazu"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "ActivityTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "reuseCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ActivityCell = self.tableView.dequeueReusableCellWithIdentifier("reuseCell") as! ActivityCell
        cell.activityDescription.text = self.tableData[indexPath.row]
        cell.activityDate.text = "not yet done"
        return cell
    }
}

