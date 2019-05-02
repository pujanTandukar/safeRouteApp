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
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate {

    // Mapview
    @IBOutlet weak var mapview: MKMapView!
    
    // Boolean for location tracking
    var locationBoolean = false
    
    // Start Tracking Location
    @IBAction func trackButton(_ sender: Any) {
        if(self.locationBoolean == false){
            let alertController = UIAlertController(title: "Start Tracking Your Location?", message: "SafeRoute will now start tracking your location.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: {action in
                self.locationBoolean = true
                globalVar.locationBooleanGlobal = true
                self.startUpdatingLocation()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
        else{
            let alertController = UIAlertController(title: "Already Tracking Your Location.", message: "SafeRoute is already tracking your location.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
    }
    
    // Updates the map with all alerts
    @IBAction func lolbutton(_ sender: Any) {
        let alertController = UIAlertController(title: "Showing all alerts", message: "SafeRoute will show you a pin at every alert posted by users.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in
            self.updateAllAlerts()
        })
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Adds a pin/annotation to every alert coordinates
    func updateAllAlerts(){
        for i in 0...allAlertCords.count-1{
            let annotation = MKPointAnnotation()
            print(allAlertCords[i].longitude, allAlertCords[i].latitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: allAlertCords[i].latitude, longitude: allAlertCords[i].longitude)
            annotation.title = "Alert"
            annotation.subtitle = "Alert"
            mapview.addAnnotation(annotation)
            print("Annotation added")
            showCircle(coordinate: CLLocationCoordinate2D(latitude: allAlertCords[i].latitude, longitude: allAlertCords[i].longitude), radius: 1000)
        }
    }
    
    // Location Manager for Mapview
    var locationManager = CLLocationManager()
    
    // All alert cordinates
    var allAlertCords = [newAlertCords]()
    
    // Adds a pin to a specific location
    class AddCoordinates: NSObject,MKAnnotation{
        var coordinate = CLLocationCoordinate2D(latitude: 40.04175206650052, longitude: -105.25711876350013)
        var title: String? = "Hi Pujan"
    }
    
    // FUNCTION: If the location services is enabled, the device starts updating location.
    func startUpdatingLocation(){
        // Determining the User location
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
    
    // Draw an overlay on the map
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate, radius: radius)
        mapview.addOverlay(circle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        mapview.delegate = self
        
        // Get current emergency contact info for authenticated/non authenticated users
        if Auth.auth().currentUser != nil {
            let currentUser = Auth.auth().currentUser?.uid
            var databaseRefForContact:DatabaseReference?
            databaseRefForContact = Database.database().reference().child("Users").child(currentUser!)
            databaseRefForContact?.observe(.childAdded, with: {(snapshot) in
                let contactInfo = snapshot.value as AnyObject
                let name = contactInfo["name"] as! String
                let number = contactInfo["number"] as! String
                print("contactInfo", contactInfo as Any)
                print("NAME", name)
                print("NUMBER", number)
                
                globalVar.currentUserContactNumber = number
                globalVar.currentUserContactName = name
            })
        }
        else{
            globalVar.currentUserContactNumber = "7202858641"
            globalVar.currentUserContactName = "Pujan Tandukar"
        }
        
        // READING FIREBASE for all alert data
        var databaseRef:DatabaseReference?
        databaseRef = Database.database().reference().child("Alerts")
        databaseRef?.observe(.childAdded, with: {(snapshot) in
            // Reading the object as a dictionary
            let post = snapshot.value as! NSDictionary
            let longitude = post["longitude"] as! Double
            let latitude = post["latitude"] as! Double
            let newAlert = newAlertCords(latitude: latitude, longitude: longitude)
            // Adding new alert to the array
            self.allAlertCords.append(newAlert)
            print("NEW ALERT",self.allAlertCords)
            print("Location",self.allAlertCords[0].longitude)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        super.viewDidAppear(animated)
        // Adding the child view to this parent.
        addBottomSheetView()
        
        // Connecting App to Widget
//        let sharedUserDefaults = UserDefaults(suiteName: "pujantandukar.SafeRoute")
//        if sharedUserDefaults.bool(forKey: "alertingPeople") {
//            alertUsers()
//        }
//        sharedUserDefaults.removeObject(forKey: "alertingPeople")
//        sharedUserDefaults.synchronize()
    }
    
    // Function that add a bottom sheet view - CHILD VIEW
    func addBottomSheetView() {
        // 1- Init drawerView
        let drawerView = ModalViewController()
        // 2- Add drawerView as a child view
        self.addChild(drawerView)
        self.view.addSubview(drawerView.view)
        drawerView.didMove(toParent: self)
        // 3- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
        drawerView.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    // CLLocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Finding the current location and setting it in mapview
        let currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        self.mapview.setRegion(currentRegion, animated: true)
        
        // Finding current location
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        globalVar.currentLat = locValue.latitude
        globalVar.currentLong = locValue.longitude
        print("locations = \(globalVar.currentLat) \(globalVar.currentLong)")
    }
    
    // Location manager failed to find location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access location")
    }
    
    // Button that uses to push location to firebase - ALERT FOR ANY DISTRUBANCES
    func alertUsers(){
        let ref = Database.database().reference()
        ref.child("Alerts").childByAutoId().setValue(["longitude":globalVar.currentLong, "latitude":globalVar.currentLat])
    }
}

// Renders a red circle as an overlay if called by the map
extension ViewController:  MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(circle: MKCircle.init())
        circleRenderer.fillColor = UIColor.red
        circleRenderer.alpha = 0.1
        return circleRenderer
    }
}
