//
//  NSString+trimFunction.swift
//  TravelDiary
//
//  Created by Peter K. Mäder on 10/03/16.
//  Copyright © 2016 PTPA. All rights reserved.
//

import Foundation

extension NSString {
    func trim() -> NSString {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}