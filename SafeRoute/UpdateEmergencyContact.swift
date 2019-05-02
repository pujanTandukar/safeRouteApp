//
//  UpdateEmergencyContact.swift
//  SafeRoute
//
//  Created by Pujan  on 4/30/19.
//  Copyright © 2019 Pujan Tandukar. All rights reserved.
//

import UIKit
import Firebase

class UpdateEmergencyContact: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactNumber: UITextField!
    @IBOutlet weak var currentContactName: UILabel!
    @IBOutlet weak var currentContactNumber: UILabel!
    
    @IBOutlet weak var logoutButtonStyle: UIButton!
    @IBOutlet weak var homeButtonStyle: UIButton!
    @IBOutlet weak var updateButtonStyle: UIButton!
    
    @IBAction func homeButton(_ sender: Any) {
        let vc = ModalViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func updateContactButton(_ sender: Any) {
        
        // getting user ID from firebase
        let userId = Auth.auth().currentUser?.uid
        print("CURRENT USER ID ", userId as Any)
        
        // using the ID to create an unique reference for each user to update the contact information
        let ref = Database.database().reference().child("Users").child(userId!)
        if(contactNumber.text == "" || contactName.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Please fill out both name and number fields.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            ref.child("Contact Info").setValue(["name": contactName.text, "number": contactNumber.text])
        }
        
        loadFromFirebase()
    }
    
    @IBAction func returnToHome(_ sender: Any) {
        // sign out
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let vc = LogInControllerViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Textfield Delegate
        self.contactName.delegate = self
        loadFromFirebase()
        
        logoutButtonStyle.layer.cornerRadius = 5
        homeButtonStyle.layer.cornerRadius = 5
        updateButtonStyle.layer.cornerRadius = 5
    }
    
    func loadFromFirebase(){
        // FIREBASE
        let currentUser = Auth.auth().currentUser?.uid
        var databaseRef:DatabaseReference?
        databaseRef = Database.database().reference().child("Users").child(currentUser!)
        databaseRef?.observe(.childAdded, with: {(snapshot) in
            let contactInfo = snapshot.value as AnyObject
            let name = contactInfo["name"] as! String
            let number = contactInfo["number"] as! String
            self.currentContactName.text = name
            self.currentContactNumber.text = number
            
            print("contactInfo", contactInfo as Any)
            print("NAME", name)
            print("NUMBER", number)
        })
    }
}
