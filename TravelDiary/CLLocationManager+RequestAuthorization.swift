//
//  LocationManager.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 06/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

extension CLLocationManager {

    func requestLocationAuthorization(viewController: UIViewController) {
        let status = CLLocationManager.authorizationStatus()
        if (status == .NotDetermined) {
            requestWhenInUseAuthorization()
        } else if (status == .Denied) {
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to display your current location, please open this app's settings and allow access to location.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            viewController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

