//
//  SignedIn.swift
//  Disturb
//
//  Created by Scott andrews on 17/12/2017.
//  Copyright © 2017 Scott Andrews. All rights reserved.
//

// Makes frameworks avaliable in the swift document
import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignedIn: UIViewController {
    
    // Set a label equel to a variable
    @IBOutlet weak var emailUsed: UILabel!
    var ref: DatabaseReference!
    
    // Runs when the view controller has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
        ref = Database.database().reference()
        
        // If user logged in
        let user = Auth.auth().currentUser
        if user != nil {
            let userID = Auth.auth().currentUser?.uid
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                // Get the users logged in email
                let email = value?["Email"] as? String ?? ""
                // Set email value to an on screen label
                self.emailUsed.text = email
            })
        }
        // End of google firebase code
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // If user taps the log out button
    @IBAction func logOut(_ sender: Any) {
        do{
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            // A google firebase method which logs the user out
            try? Auth.auth().signOut()
            // End of google firebase code
        }
        
    }
    
    // If user taps the delete account button
    @IBAction func deleteAccount(_ sender: Any) {
        
        // Send the user an alert to ask if they are sure they want to delete their account
        let alert = UIAlertController(title: "Delete Account", message: "Are You Sure You Want To Delete Your Account, All Your Data Will Be Lost", preferredStyle: UIAlertControllerStyle.alert)
        
        // If they tap the delete button on the alert then run function deleteApproved
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.cancel, handler: { action in self.deleteApproved()} ))
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    @objc func deleteApproved() {
        // Get the current logged in user
        // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
        let user = Auth.auth().currentUser
        // If user has logged in
        if user != nil {
            // A google firebase method which deletes the current logged in account
            user?.delete { error in
                // If theres an error deleting the account
                if error != nil {
                    // Alert user there has been an error in deleting their account
                    let alert = UIAlertController(title: "Error Deleting Account", message: "There Has Been An Error Deleting Your Account", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // If delete account has been succsesful then take them to the homepage
                    DispatchQueue.main.async() {
                        [unowned self] in
                        self.performSegue(withIdentifier: "accountDeleted", sender: self)
                    }
                }
            }
        }
        // End of google firebase code
    }
}
