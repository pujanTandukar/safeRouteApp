//
//  ViewController.swift
//  SafeRoute
//
//  Created by Pujan Tandukar on 2/12/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapview.showsUserLocation = true
    }


}

