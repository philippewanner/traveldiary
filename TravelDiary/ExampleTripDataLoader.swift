//
//  ExampleTripDataLoader.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 04/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit;
import CoreData;

class ExampleTripDataBuilder: BaseTripDataLoader{
    
    override func createWholeTripData() {
        self.createActivityMachuPicchu()
        self.createActivityCusco()
        self.createActivityLima()
    }
    
    private func createActivityMachuPicchu(){
        let machuPicchu = activityBuilder
            .with(description: "Reise nach Machu Picchu über den Inka Trail")
            .with(title: "Machu Picchu")
            .build()
        self.currentLocation = locationBuilder
            .with(longitude: -77.0539401)
            .with(latitude: -12.0553441)
            .with(name: "Machu Picchu, die wundervollste Stadt der Welt")
            .with(address: "Hinterland 56")
            .with(countryCode: "MP")
            .with(inActivity: machuPicchu).build()
        machuPicchu.location = self.currentLocation
        
        let imgMachu = UIImage(named: "machu_picchu")
        let compressionQuality = CGFloat(1.0)
        photoBuilder.with(title: "Machu Picchu Photo, so wunderbar")
            .with(location: self.currentLocation!)
            .with(inActivity: machuPicchu)
            .with(trip: trip)
            .with(imageData: UIImageJPEGRepresentation(imgMachu!, compressionQuality)!)
            .build()
        
        self.activities.addObject(machuPicchu)
    }
    
    private func createActivityLima(){
        let lima = activityBuilder
            .with(description: "Lima, wir werden dich nie vergessen.")
            .with(title: "Lima")
            .build()
        self.currentLocation = locationBuilder
            .with(longitude: -75.0539401)
            .with(latitude: -18.0553441)
            .with(name: "Lima, die tollste Stadt der Welt")
            .with(address: "Addresse Lima 23")
            .with(inActivity: lima)
            .with(countryCode: "PE").build()
        lima.location = self.currentLocation
        
        let imgPeru = UIImage(named: "lima_peru")
        let compressionQuality = CGFloat(1.0)
        photoBuilder.with(title: "Lima Photo, so schön")
            .with(location: self.currentLocation!)
            .with(inActivity: lima)
            .with(trip: trip)
            .with(imageData: UIImageJPEGRepresentation(imgPeru!, compressionQuality)!)
            .build()
        
        self.activities.addObject(lima)
    }
    
    private func createActivityCusco(){
        let cusco = activityBuilder
            .with(description: "Sightseeing in Cusco.")
            .with(title: "Cusco")
            .build()
        self.currentLocation = locationBuilder
            .with(longitude: -72.0092897)
            .with(latitude: -13.5298427)
            .with(name: "Cusco halt")
            .with(address: "Adresse Cusco, isch chaud dört")
            .with(inActivity: cusco)
            .with(countryCode: "PE").build()
        cusco.location = self.currentLocation
        
        let imgCusco = UIImage(named: "cusco_peru")
        let compressionQuality = CGFloat(1.0)
        photoBuilder.with(title: "Cusco Photo, so wooaa")
            .with(location: self.currentLocation!)
            .with(inActivity: cusco)
            .with(trip: trip)
            .with(imageData: UIImageJPEGRepresentation(imgCusco!, compressionQuality)!)
            .build()
        
        self.activities.addObject(cusco)
    }
}