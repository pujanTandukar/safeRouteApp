//
//  TodayViewController.swift
//  SafeRoute Widget
//
//  Created by Pujan Tandukar on 2/14/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    
    var locationManager =  CLLocationManager()
    @IBAction func alertButton(_ sender: Any) {
        print("Alert")
        let sharedUserDefaults = UserDefaults(suiteName: "pujantandukar.SafeRoute")!
        sharedUserDefaults.set(true, forKey: "alertingPeople")
        sharedUserDefaults.synchronize()
    }
    
    @IBAction func callButton(_ sender: Any) {
        print("Call")
//        callNumber(phoneNumber: <#T##String#>)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
