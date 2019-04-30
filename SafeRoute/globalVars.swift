//
//  globalVars.swift
//  SafeRoute
//
//  Created by Pujan Tandukar on 4/18/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import Foundation

struct globalVar {
    static var isLocationOn = false
    static var currentLong = 0.0
    static var currentLat = 0.0
}

struct alertCoordinates {
    let day: Int
    var latitude: Double
    var longitude: Double
    var month: Int
}

class meroCords: NSObject {
    var latitude: AnyObject!
    var longitude: AnyObject!
}

struct newAlertCords{
    var latitude: Double
    var longitude: Double
}

