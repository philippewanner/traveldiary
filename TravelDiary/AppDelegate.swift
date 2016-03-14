//
//  AppDelegate.swift
//  TravelDiary
//
//  Created by Andreas Heubeck on 08/02/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import UIKit
import CoreData;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreDataController = CoreDataController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let dataLoader = SampleDataLoader(managedObjectContext: coreDataController.managedObjectContext)
        dataLoader.loadSampleDataIfNotExists()
        setApplicationColorTheme()
        return true
    }
    
    func setApplicationColorTheme() {
        let tealColor = RGB(79, 183, 193)
        
        // Application tintColor
        window?.tintColor = tealColor
        
        // Navigation bar background color
        UINavigationBar.appearance().barTintColor = tealColor
        
        // Make the back button white (instead of the global tintColor)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // Make the text in the navigation bar white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    private func RGB(r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

