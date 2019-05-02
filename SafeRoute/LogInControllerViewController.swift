//
//  LogInControllerViewController.swift
//  SafeRoute
//
//  Created by Pujan  on 4/30/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit
import Firebase

class LogInControllerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButtonStle: UIButton!
    @IBOutlet weak var signupButtonStyle: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error == nil{
                let vc = UpdateEmergencyContact()
                self.present(vc, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Please Try Again.", message: "The email and password combination is not valid.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        let vc = SignUpViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
