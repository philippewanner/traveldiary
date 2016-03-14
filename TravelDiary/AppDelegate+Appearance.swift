//
//  Appearance.swift
//  TravelDiary
//
//  Created by Tobias Rindlisbacher on 14/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    
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
