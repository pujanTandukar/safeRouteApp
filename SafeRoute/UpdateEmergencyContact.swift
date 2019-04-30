//
//  UpdateEmergencyContact.swift
//  SafeRoute
//
//  Created by Pujan  on 4/30/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit
import Firebase

class UpdateEmergencyContact: UIViewController {

    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBAction func updateContactButton(_ sender: Any) {
    }
    @IBAction func returnToHome(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
