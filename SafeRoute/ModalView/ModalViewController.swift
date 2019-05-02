//
//  DrawerViewController.swift
//  SafeRoute
//
//  Created by Pujan Tandukar on 2/26/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class ModalViewController: UIViewController,  CLLocationManagerDelegate{
    
    var controller = ViewController()
    var locationManager = CLLocationManager()
    
    @IBOutlet var swipeLabel: UILabel!
    @IBAction func button1(_ sender: UIButton) {
        print("Start tracking my location.")
    }
    
    @IBAction func button2(_ sender: Any) {
        print("Stop tracking my location.")
//        controller.updateAllAlerts()
    }
    
    @IBAction func button3(_ sender: Any) {
        print("Alert nearby users.")
        
        let alert = UIAlertController(title: "Alerting nearby people.", message: "This will alert nearby users that you are under threat.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Alert", style: .default, handler: {action in
            self.controller.alertUsers()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func button4(_ sender: Any) {
        print("Alert emergency contact.", globalVar.currentUserContactNumber)
        callNumber(phoneNumber: globalVar.currentUserContactNumber)
    }
    
    @IBAction func button5(_ sender: Any) {
        print("Edit emergency contact.")
        
        if Auth.auth().currentUser != nil {
            let vc = UpdateEmergencyContact()
            self.present(vc, animated: true, completion: nil)
        }
        else{
            let vc = LogInControllerViewController()
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    // Function that is used to call a phone number
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 10

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ModalViewController.panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animating the bottom sheet appearance
        UIView.animate(withDuration: 0.3) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 110
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }
    
    // Add blur and vibrancy effects
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        view.insertSubview(bluredView, at: 0)
        view.backgroundColor = UIColor.clear
    }
    
    // Gesture behaviour
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let y = self.view.frame.minY
        let velocity = recognizer.velocity(in: self.view)
        
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            swipeLabel.text = "Swipe down to close!"
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView - 60, width: self.view.frame.width, height: self.view.frame.height)
                    self.swipeLabel.text = "Swipe up to start!"
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
            }, completion: nil)
        }
    }
}
