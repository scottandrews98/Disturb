//
//  Home.swift
//  Disturb
//
//  Created by Scott Andrews on 13/12/2017.
//  Copyright © 2017 Scott Andrews. All rights reserved.
//

// Makes frameworks avaliable in the swift document
import UIKit
import FirebaseAuth
import FirebaseDatabase
import WatchConnectivity
import Onboard

// code needed for information to be sent to the watchOS application
class Home: UIViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    // Creates a varible that holds the label values into variables
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var biggestHight: UILabel!
    @IBOutlet weak var level: UILabel!
    
    var ref: DatabaseReference!
    
    // Runs when the view controller has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        // If a value is set then set the value of the coins label to the value of the total coins
        if UserDefaults.standard.value(forKey: "coin") != nil {
            coins.text = "Coins: " + String(describing: UserDefaults.standard.value(forKey: "coin")!)
        }
        
        // If a value is set then set the value of the high score label to the value of the high score
        if UserDefaults.standard.value(forKey: "high") != nil {
            biggestHight.text = "High Score: " + String(describing: UserDefaults.standard.value(forKey: "high")!)
        }
        
        // Set the value of the current logged in user
        let user = Auth.auth().currentUser
        // If a user is logged in then run
        if user != nil {
            // Get users unique id
            let userID = Auth.auth().currentUser?.uid
            // Get information from the database for specific user
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let black = value?["Black"] as? String ?? ""
                let green = value?["Green"] as? String ?? ""
                let red = value?["Red"] as? String ?? ""
                let coins = value?["Coins"] as? String ?? ""
                let high = value?["High"] as? String ?? ""
                let totalTime = value?["TotalTime"] as? String ?? ""
                let broughtTime = value?["BroughtTime"] as? String ?? ""
                
                // Set value of coins to the users local storage
                UserDefaults.standard.set(coins, forKey: "coin")
                UserDefaults.standard.set(high, forKey: "high")
                UserDefaults.standard.set(totalTime, forKey: "totalTime")
                UserDefaults.standard.set(broughtTime, forKey: "broughtTime")
                
                // If the black ball has been brought then set it on local storage
                if Int(black) != nil{
                    UserDefaults.standard.set(black, forKey: "black")
                }
                if Int(green) != nil{
                    UserDefaults.standard.set(green, forKey: "green")
                }
                if Int(red) != nil{
                    UserDefaults.standard.set(red, forKey: "red")
                }
            })
        }
        
        // If there has been a total time saved to local storage before then run
        if UserDefaults.standard.value(forKey: "totalTime") != nil {
            // Get the total time
            let time = UserDefaults.standard.integer(forKey: "totalTime")
            // Get the total time that has been pruchased from the store
            let broughtTime = UserDefaults.standard.integer(forKey: "broughtTime")
            // Work out the total number of hours from the total seconds
            let hoursLeft = (time + broughtTime) / 3600
            // Round the number to the nearest time
            let levelNumber = Int(floor(Double(hoursLeft)))
            // Set the level label to the total level that the user has achieved
            level.text = "Level " + String(levelNumber)
            
            // If time is more than or equel to 100 hours then cap the level at 100
            if time >= 360000{
                level.text = "Level " + "100"
            }
        }
        
        // Start the watch data sending session
        let session = WCSession.default
        session.delegate = self
        session.activate()
        
        // Run function send watch
        sendWatch()
        
    }
    
    
    // Code for the onboarding screen which is shown to users on their first launch of the application.
    override func viewDidAppear(_ animated: Bool) {
        
        // Amaral, M. (2018). mamaral/Onboard. [online] GitHub. Available at: https://github.com/mamaral/Onboard [Accessed 23 Apr. 2018].
        
        // If user has not seen the onboarding screen before
        if UserDefaults.standard.value(forKey: "SeenOnboard") == nil {
            // Set the text for the first page of the onboarding screen
            let firstPage = OnboardingContentViewController(title: "Avoid Distractions", body: "Disturb makes sure that you are rewarded with giving you coins for the longer you spend on the app", image: UIImage(named: "phone"), buttonText: nil) { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            }
            
            // Set the text for the second page of the onboarding screen
            let secondPage = OnboardingContentViewController(title: "Get More Done", body: "Disturb helps you avoid distractions by enticing you to stay on the app.", image: UIImage(named: "clock"), buttonText: "Start Now") { () -> Void in
                UserDefaults.standard.set("hasSeen", forKey: "SeenOnboard")
                self.dismiss(animated: true, completion: nil)
            }
            
            // Set the background image for the onboarding screens
            let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "onboardBackground") , contents: [firstPage, secondPage])
            
            // Set the styles for the onbaording screens
            onboardingVC?.shouldMaskBackground = false
            secondPage.movesToNextViewController = true
            
            firstPage.underTitlePadding = 40
            firstPage.underIconPadding = 40
            
            secondPage.underTitlePadding = 40
            secondPage.underIconPadding = 40
            
            secondPage.actionButton.layer.borderWidth = 2
            secondPage.actionButton.layer.borderColor = UIColor.white.cgColor
            
            self.present(onboardingVC!, animated: true, completion: nil)
        }
    }
    // End of onboarding screen plugin

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // If the profile icon is clicked
    @IBAction func profile(_ sender: Any) {
    // Firebase. (2018). Offline Capabilities on iOS  |  Firebase Realtime Database  |  Firebase. [online] Available at: https://firebase.google.com/docs/database/ios/offline-capabilities [Accessed 4 Mar. 2018].
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
    //  Referenced code ends here
                // If the user logged in
                if (Auth.auth().currentUser != nil) {
                    // Go to the already logged in screen
                    self.performSegue(withIdentifier: "AlreadySignedIn", sender: self)
                }else{
                    // Go to the log in screen
                    self.performSegue(withIdentifier: "noSignIn", sender: self)
                }
            } else {
                // Alert the user that they have no internet connection
                let alert = UIAlertController(title: "No Connection", message: "Because You Have No Connection You Can Not Go To The Account Section", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
        // End of google firebase code
    }
    
    func sendWatch(){
        let high = UserDefaults.standard.integer(forKey: "high")
        let money = UserDefaults.standard.integer(forKey: "coin")
        let lattiude = UserDefaults.standard.double(forKey: "latitude")
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        
        // Assign the data into a dictionry ready to be transmitted to the watch
        let applicationDic: [String:Any] = ["high": String(high), "coin":String(money),"lattitude": lattiude, "longitude": longitude ]
        
        // Send the data to the watch if avaliable 
        WCSession.default.transferUserInfo(applicationDic)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
