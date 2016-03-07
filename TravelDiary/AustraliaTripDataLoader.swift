//
//  AustraliaTripDataLoader.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 04/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit;
import CoreData;

class AustraliaTripDataLoader: BaseTripDataLoader{
    
    override func createWholeTripData(){
        self.createActivityDownUnder()
    }
    
    private func createActivityDownUnder(){
        let australia = activityBuilder
            .with(description: "Ausflug zum Uluru, Olga's, Kings canyon")
            .with(title: "Outback")
            .build()
        self.currentLocation = locationBuilder
            .with(longitude: -102.0539401)
            .with(latitude: -99.0553441)
            .with(name: "The great Down Under")
            .with(address: "Outback 987")
            .with(countryCode: "AU")
            .with(inActivity: australia).build()
        australia.location = self.currentLocation
        self.activities.addObject(australia)
    }
}