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
import FirebaseDatabase
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapview: MKMapView!
    var locationManager = CLLocationManager()
    
    var alertCord = [alertCoordinates]()

    class AddCoordinates: NSObject,MKAnnotation{
        var coordinate = CLLocationCoordinate2D(latitude: 40.001230108641096, longitude: -105.26926145898669)
//        var title: String? = "Hi Pujan"
    }
    
    @IBAction func button(_ sender: Any) {
        startUpdatingLocation()
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view, typically from a nib.
        
//        addCircleOver(radius: 100)
        // Adding a circle any disturbances
        mapview.addAnnotation(AddCoordinates())
//        UserDefaults.init(suitName: "group.pujantandukar.widget")
//        UserDefaults.init(suiteName: "group.pujantandukar.widget")?.set(alertUsers(), forKey: alertUsers)
        
        var databaseRef:DatabaseReference?
        
        databaseRef = Database.database().reference()
        databaseRef?.observe(.childAdded, with: {(snapshot) in
            let post = snapshot.value as! NSDictionary
//            let post = snapshot.value as! [String : AnyObject]
//            let object = meroCords()
//            object.setValuesForKeys(post)
//            meroCord.append(object)
            print(post)
//            for i in post{
//
//            }
            let longitude = post["longitude"]
            let latitude = post["latitude"]
            print(longitude as Any, latitude as Any)
//            for i in post{
//                print(i)
//            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheetView()
    }
    
    // Function that add a bottom sheet view - CHILD VIEW
    func addBottomSheetView() {
        // 1- Init drawerView
//        let drawerView = DrawerViewController()
//        let drawerView = TableViewModalController()
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
        let currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        self.mapview.setRegion(currentRegion, animated: true)
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        globalVar.currentLat = locValue.latitude
        globalVar.currentLong = locValue.longitude
//        currentLat = locValue.latitude
//        currentLong = locValue.longitude
        print("locations = \(globalVar.currentLat) \(globalVar.currentLong)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access location")
    }
    
    // Button that uses to push location to firebase - ALERT FOR ANY DISTRUBANCES
    func alertUsers(){
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        let ref = Database.database().reference()
//        ref.childByAutoId().setValue(["longitude":globalVar.currentLong, "latitude":globalVar.currentLat, "day": day, "month": month ])
        ref.childByAutoId().setValue(["longitude":globalVar.currentLong, "latitude":globalVar.currentLat])
    }
    
    // Function that adds circle overlay to the map
//    func addCircleOver(radius:CLLocationDistance){
//        let center = CLLocationCoordinate2D(latitude: 40.0150, longitude: 105.2705)
//        let circle = MKCircle(center: center, radius: radius)
////        mapView.addOverlay(circle)
//        mapview.addOverlay(circle)
//    }
//
//    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay.isKind(of: MKCircle.self){
//            let circleRenderer = MKCircleRenderer(overlay: overlay)
//            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
//            circleRenderer.strokeColor = UIColor.blue
//            circleRenderer.lineWidth = 1
//            return circleRenderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
    
    func addRegion(_ sender: Any) {
        print("addregion pressed")
        guard let longPress = sender as? UILongPressGestureRecognizer else {return}
        
        let touchLocation = longPress.location(in: mapview)
        let coordinates = mapview.convert(touchLocation, toCoordinateFrom: mapview)
        let region = CLCircularRegion(center: coordinates, radius: 5000, identifier: "geofence")
        mapview.removeOverlays(mapview.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinates, radius: region.radius)
        mapview.addOverlay(circle)
        
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circelOverLay = overlay as? MKCircle else {return MKOverlayRenderer()}
        
        let circleRenderer = MKCircleRenderer(circle: circelOverLay)
        circleRenderer.strokeColor = .blue
        circleRenderer.fillColor = .blue
        circleRenderer.alpha = 0.2
        return circleRenderer
    }
}

