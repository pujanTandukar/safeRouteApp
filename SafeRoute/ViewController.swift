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

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapview: MKMapView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapview.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
        } else {
            print("Please turn on location services")
        }
    }
    
    // CLLocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
//        self.mapview.region = currentRegion
        self.mapview.setRegion(currentRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access location")
    }


}

