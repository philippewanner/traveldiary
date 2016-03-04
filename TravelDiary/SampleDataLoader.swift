//
//  SampleDataLoader.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData;

class SampleDataLoader: BaseSampleDataLoader{
    
    func loadSampleDataIfNotExists() {
        ExampleTripDataBuilder(tripTitle: "An Example Trip", managedObjectContext: self.context).buildAndSaveIfNotExists()
        AustraliaTripDataLoader(tripTitle: "Australia", managedObjectContext: self.context).buildAndSaveIfNotExists()
    }
}