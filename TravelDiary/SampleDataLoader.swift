//
//  ExampleDataBuilder.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 03/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData;

class SampleDataLoader: BaseDataLoader{
    
    private func createSampleData() {
        self.createFirstTrip()
        self.saveData()
        self.createSecondTrip()
        self.saveData()
    }
    
    private func createFirstTrip(){
        let tripTitle = "ExampleTrip"
        if(isSampleTripDataAlreadyLoaded(sampleTripTitle: tripTitle)) {return}
        
        let trip = tripBuilder.with(title: tripTitle).build()
        
        var location: Location
        let machuPicchu = activityBuilder.with(description: "Machu Picchu").build()
        location = locationBuilder
            .with(longitude: -77.0539401)
            .with(latitude: -12.0553441)
            .with(name: "Machu Picchu, die wundervollste Stadt der Welt")
            .with(address: "Hinterland 56")
            .with(countryCode: "MP")
            .with(inActivity: machuPicchu).build()
        machuPicchu.location = location
        
        let lima = activityBuilder.with(description: "Lima, wir werden dich nie vergessen.").build()
        location = locationBuilder
            .with(longitude: -75.0539401)
            .with(latitude: -18.0553441)
            .with(name: "Lima, die tollste Stadt der Welt")
            .with(address: "Addresse Lima 23")
            .with(inActivity: machuPicchu)
            .with(countryCode: "PE").build()
        lima.location = location
        let imgPeru = UIImage(named: "lima_peru_thumb")
        let compressionQuality = CGFloat(1.0)
        photoBuilder.with(title: "Lima Photo, so schön")
            .with(location: location)
            .with(inActivity: lima)
            .with(trip: trip)
            .with(imageData: UIImageJPEGRepresentation(imgPeru!, compressionQuality)!)
            .build()
        
        let cusco = activityBuilder.with(description: "Cusco").build()
        location = locationBuilder.with(longitude: -72.0092897).with(latitude: -13.5298427)
            .with(name: "Cusco halt")
            .with(address: "Adresse Cusco, isch chaud dört")
            .with(inActivity: cusco)
            .with(countryCode: "PE").build()
        cusco.location = location
        
        let activities = NSMutableSet()
        activities.addObject(machuPicchu)
        activities.addObject(lima)
        activities.addObject(cusco)
        trip.activities = activities
    }
    
    private func createSecondTrip(){
        let tripTitle = "Another trip far far away"
        if(isSampleTripDataAlreadyLoaded(sampleTripTitle: tripTitle)) {return}
        
        let trip = tripBuilder.with(title: tripTitle).build()
        
        var location: Location
        let australia = activityBuilder.with(description: "Australia").build()
        location = locationBuilder
            .with(longitude: -102.0539401)
            .with(latitude: -99.0553441)
            .with(name: "The great Down Under")
            .with(address: "Outback 987")
            .with(countryCode: "AU")
            .with(inActivity: australia).build()
        australia.location = location
        
        let activities = NSMutableSet()
        activities.addObject(australia)
        trip.activities = activities
    }
    
    func loadSampleDataIfNotExists(){
        createSampleData()
    }
}