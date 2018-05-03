//
//  SignIn.swift
//  Disturb
//
//  Created by Scott Andrews on 14/12/2017.
//  Copyright © 2017 Scott Andrews. All rights reserved.
//

// Makes frameworks avaliable in the swift document
import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignIn: UIViewController {

    // Creates a varible that holds the label values into variables
    @IBOutlet weak var messages: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var ref: DatabaseReference!
    
    // Runs when the view controller has loaded
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        // Do any additional setup after loading the view.
        // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
        ref = Database.database().reference()
        // End of google firebase code
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Run if user taps the sign in button
    @IBAction func SignIn(_ sender: Any) {
        // Ask the user if they want to sign in
        let alert = UIAlertController(title: "Sign In", message: "Are You Sure You Want To Sign In, Your Current Progress Will Be Overwritten", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Sign In", style: UIAlertActionStyle.cancel, handler: { action in self.signInApproved()} ))
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // Run if user taps the sign in button on the alert
    @objc func signInApproved() {
        // Set emailReal to the email input and set passwordReal to the password input
        if let emailReal = email.text, let passwordReal = password.text{
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            // Google firebase sign in method with email and password
            Auth.auth().signIn(withEmail: emailReal, password: passwordReal) { (user, error) in
                // If signin has been succsfull
                if user != nil{
                    // Set label to show signed in
                    self.messages.text = "Signed In"
                    var coin = ""
                    var high = ""
                    var longitude = ""
                    var latitude = ""
                    var totalTime = ""
                    var broughtTime = ""
                    var black = ""
                    var red = ""
                    var green = ""
                    
                    // Get the current user unique identifier
                    let userID = Auth.auth().currentUser?.uid
                    // Get the data from the database for that user
                    self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        // Assign the data from database to variables
                        coin = value?["Coins"] as? String ?? ""
                        high = value?["High"] as? String ?? ""
                        longitude = value?["Longitude"] as? String ?? ""
                        latitude = value?["Latitude"] as? String ?? ""
                        totalTime = value?["TotalTime"] as? String ?? ""
                        broughtTime = value?["BroughtTime"] as? String ?? ""
                        black = value?["Black"] as? String ?? ""
                        red = value?["Red"] as? String ?? ""
                        green = value?["Green"] as? String ?? ""
                    // End of google firebase code
                        // Set these into the users local storage
                        UserDefaults.standard.set(coin, forKey: "coin")
                        UserDefaults.standard.set(high, forKey: "high")
                        UserDefaults.standard.set(longitude, forKey: "longitude")
                        UserDefaults.standard.set(latitude, forKey: "latitude")
                        UserDefaults.standard.set(totalTime, forKey: "totalTime")
                        UserDefaults.standard.set(broughtTime, forKey: "broughtTime")
                        
                        // If user has purchased the black ball then set it into local storage
                        if black == "Black"{
                            UserDefaults.standard.set(black, forKey: "black")
                        }
                        
                        // If user has purchased the red ball then set it into local storage
                        if red == "Red"{
                            UserDefaults.standard.set(red, forKey: "red")
                        }
                        
                        // If user has purchased the green ball then set it into local storage
                        if green == "Green"{
                            UserDefaults.standard.set(green, forKey: "green")
                        }
                        
                        self.performSegue(withIdentifier: "backToHome", sender: self)
                    })
                    
                }
                
                // If user sign in failed
                if  error != nil{
                    // Set label and alert that username or password wrong
                    self.messages.text = "Wrong Email Or Password"
                    let alert = UIAlertController(title: "Wrong Login Details", message: "Please Try A Different Username And Password", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

    }
    
    // Run if the user taps the register button
    @IBAction func Register(_ sender: Any) {

        let emailReal = email.text
        let passwordReal = password.text
        var longitude = 0.0
        var latitude = 0.0
        var totalTime = 0
        var broughtTime = 0
        
        // Run if there is a value in local sotrage called longitude
        if UserDefaults.standard.value(forKey: "longitude") != nil {
            longitude = UserDefaults.standard.double(forKey: "longitude")
            latitude = UserDefaults.standard.double(forKey: "latitude")
        }else{
            longitude = 0.0
            latitude = 0.0
        }
        
        // Run if there is a value in local storage called totalTime
        if UserDefaults.standard.value(forKey: "totalTime") != nil{
            totalTime = UserDefaults.standard.integer(forKey: "totalTime")
        }
        
        // Run if there is a value in local storage called broughTime
        if UserDefaults.standard.value(forKey: "broughtTime") != nil{
            broughtTime = UserDefaults.standard.integer(forKey: "broughtTime")
        }
        
        // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
        // Create a new user on the backend with the email input and password input
        Auth.auth().createUser(withEmail: emailReal!, password: passwordReal!) { (user, error) in
            
            // If user has been registered succsefully
            if user != nil{
                // Set variables to contain the current money and high score value
                let option1 = String(UserDefaults.standard.integer(forKey: "coin"))
                let option2 = String(UserDefaults.standard.integer(forKey: "high"))
                
                // Set the label to say that the user has been registered
                self.messages.text = "Registered"
                // Set the database row of the user to values that are already set
                self.ref.child("users").child((user?.uid)!).child("Email").setValue(emailReal)
                self.ref.child("users").child((user?.uid)!).child("Coins").setValue(option1)
                self.ref.child("users").child((user?.uid)!).child("High").setValue(option2)
                self.ref.child("users").child((user?.uid)!).child("Longitude").setValue(String(longitude))
                self.ref.child("users").child((user?.uid)!).child("Latitude").setValue(String(latitude))
                self.ref.child("users").child((user?.uid)!).child("TotalTime").setValue(String(totalTime))
                self.ref.child("users").child((user?.uid)!).child("BroughtTime").setValue(String(broughtTime))
            // End of google firebase code
                // Run if user has purchased a black ball
                if UserDefaults.standard.value(forKey: "black") != nil{
                    self.ref.child("users").child((user?.uid)!).child("Black").setValue("Black")
                }
                if UserDefaults.standard.value(forKey: "green") != nil{
                    self.ref.child("users").child((user?.uid)!).child("Green").setValue("Green")
                }
                if UserDefaults.standard.value(forKey: "red") != nil{
                    self.ref.child("users").child((user?.uid)!).child("Red").setValue("Red")
                }
                
                // Run an alert that the user has succsesfully registered
                let alert = UIAlertController(title: "Succsessfully Registered", message: "Please Now Login", preferredStyle: UIAlertControllerStyle.alert)
                    
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                self.present(alert, animated: true, completion: nil)
            }
            
            // If there has been an error registering
            if error != nil{
                let passwordOne = self.password.text
                
                // If password is less than 8 characters long
                if (passwordOne?.count)! < 8{
                    // Set label to say that the password must be longer
                    self.messages.text = "Password Must Be Longer Than 8 Characters"
                }else{
                    // Set label to say that there has been a registration error
                    self.messages.text = "Registration Error"
                    
                    // Alert the user that there has been a registration error
                    let alert = UIAlertController(title: "Error Registering User", message: "Username Or Password Wrong", preferredStyle: UIAlertControllerStyle.alert)
                        
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Run if user taps the forgot password button
    @IBAction func forgotPassword(_ sender: Any) {
        // If user has entered sn email
        if let emailReal = email.text{
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            // Send google firebase a forgot password request with an account that has a registered email
            Auth.auth().sendPasswordReset(withEmail: emailReal) { (error) in
            // End of google firebase code
                // If there has been an error requesting a new password
                if  error != nil{
                    // Alert the user that there is no account registered with the email they entered
                    let alert = UIAlertController(title: "Email Not Found", message: "There Is Not An Account Reggistered In This Email", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    // Set label to tell user that their email has not been found
                    self.messages.text = "Email Not Found"
                    
                }else{
                    
                    // If there has been no error then run an alert to tell user that they have been sent a password reset email
                    let alert = UIAlertController(title: "Password Reset Succses", message: "A password reset email has been sent to your email", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else {
            // Run if there has been any other error
            self.messages.text = "Error Resetting Password"
        }
    }
    

}
