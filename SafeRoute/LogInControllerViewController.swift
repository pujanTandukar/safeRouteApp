//
//  LogInControllerViewController.swift
//  SafeRoute
//
//  Created by Pujan  on 4/30/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit

class LogInControllerViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        let vc = UpdateEmergencyContact()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signupButton(_ sender: Any) {
        let vc = SignUpViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
