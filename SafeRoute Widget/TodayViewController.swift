//
//  TodayViewController.swift
//  SafeRoute Widget
//
//  Created by Pujan Tandukar on 2/14/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBAction func alertButton(_ sender: Any) {
        print("Alert")
    }
    
    @IBAction func callButton(_ sender: Any) {
        print("Call")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
