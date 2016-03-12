//
//  CLLocation+FormattedAdress.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 12/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    
    func formattedAddressLines() -> String? {
        guard let addressDictionary = addressDictionary, let formattedAddressLines = addressDictionary["FormattedAddressLines"] as? [String]
        else {
            return nil
        }
        return formattedAddressLines.flatMap({$0}).joinWithSeparator(", ")
    }
    
}
