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
}

