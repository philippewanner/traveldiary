//
//  SouthAmericaTripLoader.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 07/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData

class SouthAmericaTripLoader: BaseTripDataLoader{
    
    override func createWholeTripData(){
        self.createIguazuActivity()
    }
    
    private func createIguazuActivity(){
        let iguazu = activityBuilder
            .with(description: "Ausflug zu den Wasserfällen von Iguazu. Beide Seiten(Argentinien und Barsilien).")
            .with(title: "Carataras de Iguazu")
            .build()
        self.currentLocation = locationBuilder
            .with(longitude: -54.444981)
            .with(latitude: -25.686785)
            .with(name: "Iguazu Wasserfälle")
            .with(address: "")
            .with(countryCode: "BR")
            .with(inActivity: iguazu).build()
        iguazu.location = self.currentLocation
        
        for index in 1...29{
            let imgMachu = UIImage(named: "Iguazu"+String(index))
            let compressionQuality = CGFloat(1.0)
            photoBuilder.with(title: "Iguazu")
                .with(location: self.currentLocation!)
                .with(inActivity: iguazu)
                .with(trip: trip)
                .with(imageData: UIImageJPEGRepresentation(imgMachu!, compressionQuality)!)
                .build()
        }
        self.activities.addObject(iguazu)
    }
}
