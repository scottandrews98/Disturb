//
//  ViewController.swift
//  Disturb
//
//  Created by Scott Andrews on 10/12/2017.
//  Copyright © 2017 Scott Andrews. All rights reserved.
//

// Makes frameworks avaliable in the swift document
import UIKit
import AudioToolbox
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate,  CLLocationManagerDelegate{
    
    // creates a varible that holds the banner values into variables
    @IBOutlet weak var banner: GADBannerView!
    
    // creates a varible that holds the label values into variables
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    
    // creates a varible that holds the progress values into variables
    @IBOutlet weak var progress: UIProgressView!
    
    var ref: DatabaseReference!
    
    // Set a value from local storage to a variable
    var high = UserDefaults.standard.integer(forKey: "high")
    
    // Set a value from local storage to a variable
    var money = UserDefaults.standard.integer(forKey: "coin")
    
    // The total number of seconds in an hour
    var Mins = 1500
    var countUp = 0
    var totalScore = 0
    
    // Set a variable which is equel to the current screen brightness
    let currentBrightness = UIScreen.main.brightness
    
    var toggle = false
    
    // Create a variable equel to the timer method
    var timer = Timer()
    
    // Create all of the balls and give them all boundires to comply with
    var blackDot = UIView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 12.5, y: UIScreen.main.bounds.height/2 - 12.5, width: 25, height: 25))
    var redDot = UIView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 12.5, y: UIScreen.main.bounds.height/2 - 12.5, width: 25, height: 25))
    var greenDot = UIView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 12.5, y: UIScreen.main.bounds.height/2 - 12.5, width: 25, height: 25))
    
    // Set a variable equel to a location manager method
    let location = CLLocationManager()
    
    // Run when the view controller loads
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Set the varible equel to a timer which will run a function every 1 second and repeat
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timing), userInfo: nil, repeats: true)
        
        // Declare the width and heigh of the progress bar
        progress.transform = progress.transform.scaledBy(x: 1, y: 600)
        // Send the progress bar to the back of the view
        self.view.sendSubview(toBack: progress)
        
        // Code responsible for monitoring if the user has left the app
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
        ref = Database.database().reference()
        // End of google firebase code
        
        // Stop screen diming after a set time the user has chosen
        UIApplication.shared.isIdleTimerDisabled = true
        
        //Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
        // If user is logged in
        let user = Auth.auth().currentUser
        if user != nil {
        // End of google firebase code
            
            //Google Developers. (2018). Google Mobile Ads SDK  |  Google Mobile Ads SDK for iOS  |  Google Developers. [online] Available at: https://developers.google.com/admob/ios/download [Accessed 23 Apr. 2018].
            
            // Request a banner advert from Google
            let request = GADRequest()
            // A test device ID so that test ads are only shows on this device for testing
            request.testDevices = ["aa7be57d6db0a5948bc7f146e05e04cb"]
            
            // My ad unit ID
            banner.adUnitID = "ca-app-pub-5657362465242162/6343529267"
            
            banner.rootViewController = self
            banner.delegate = self
            // Load a banner advert
            banner.load(request)
        }else{
            // The same but runs if user is not logged in
            let request = GADRequest()
            request.testDevices = ["aa7be57d6db0a5948bc7f146e05e04cb"]
            
            banner.adUnitID = "ca-app-pub-5657362465242162/6343529267"
            
            banner.rootViewController = self
            banner.delegate = self
            banner.load(request)
            
            // End of google mobile ads SDK code
        }
        
        // Ask for permission to use location information
        location.requestWhenInUseAuthorization()
        location.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Run when view appears on screen after it has loaded
    override func viewDidAppear(_ animated: Bool) {
        
        // If user has purchased a black ball
        if UserDefaults.standard.value(forKey: "black") != nil {
            // Make it visible by setting the background colour to black
            blackDot.backgroundColor=UIColor.black
            // Make it a circle by rounding the corners
            blackDot.layer.cornerRadius = 10
            // Add the blackdot to the view
            self.view.addSubview(blackDot)
        }
        
        if UserDefaults.standard.value(forKey: "red") != nil {
            redDot.backgroundColor=UIColor.red
            redDot.layer.cornerRadius = 10
            self.view.addSubview(redDot)
        }
        
        if UserDefaults.standard.value(forKey: "green") != nil {
            greenDot.backgroundColor=UIColor.green
            greenDot.layer.cornerRadius = 10
            self.view.addSubview(greenDot)
        }
        
        // Runs function animate every 5 seconds which is responsible for moving the balls
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    
    @objc func animate(){
        // Gets the overall screen height and width for the device
        let screenBounds = UIScreen.main.bounds
        // Sets the width
        let screenWidth = screenBounds.width - 25
        // Sets the height
        let screenHight = screenBounds.height - 25
        
        // Runs a UIView animation
        UIView.animate(withDuration: 5.0){
            let across = arc4random_uniform(UInt32(screenWidth))
            let height = arc4random_uniform(UInt32(screenHight))
            self.blackDot.frame.origin.x = CGFloat(across)
            self.blackDot.frame.origin.y = CGFloat(height)
        }
        
        UIView.animate(withDuration: 5.0){
            let across = arc4random_uniform(UInt32(screenWidth))
            let height = arc4random_uniform(UInt32(screenHight))
            self.redDot.frame.origin.x = CGFloat(across)
            self.redDot.frame.origin.y = CGFloat(height)
        }
        
        UIView.animate(withDuration: 5.0){
            let across = arc4random_uniform(UInt32(screenWidth))
            let height = arc4random_uniform(UInt32(screenHight))
            self.greenDot.frame.origin.x = CGFloat(across)
            self.greenDot.frame.origin.y = CGFloat(height)
        }
  
    }
    

    @objc func timing(){
        // Take away one fom Mins every second
        Mins -= 1
        // Display the new time left to the user
        let minutesLeft = Int(Mins) / 60 % 60
        let secondsLeft = Int(Mins) % 60
        
        // If seconds left is less than 10 then display a 0 before the number
        if secondsLeft < 10 {
            timeLeft.text = "\(minutesLeft):0\(secondsLeft)"
        }else{
            timeLeft.text = "\(minutesLeft):\(secondsLeft)"
        }
        
        // Set a local storage value for the money value
        UserDefaults.standard.set(money , forKey:"coin")
        
        // Add one to countup
        countUp += 1
        // Create percentage value from the time left
        let percentage = Float(countUp) / 1500
        // Set the progress bar to the percentage just created
        progress.setProgress(percentage, animated: true)
        
        // If there is a value set for totalTime in local storage
        if UserDefaults.standard.value(forKey: "totalTime") != nil{
            // Set a variable to an integer value of totalTime
            var time = UserDefaults.standard.integer(forKey: "totalTime")
            // Add one to time
            time = time + 1
            // Update the totalTime local storage variable with the new time
            UserDefaults.standard.set(time, forKey: "totalTime")
            
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            // If user is logged in
            let user = Auth.auth().currentUser
            if let user = user {
                // Set the new updated time to the database
                self.ref.child("users").child((user.uid)).child("TotalTime").setValue(String(time))
            }
            // End of google firebase code
        }else{
            UserDefaults.standard.set(0, forKey: "totalTime")
        }
        
        // If the time equels 0
        if Mins == 0 {
            // Add 1500 seconds to Mins
            Mins = Mins + 1500
            totalScore = totalScore + 1
            total.text = String(totalScore)
            countUp = 0
            // Vibrate the phone
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            // Add one coin
            money = money + 1
            
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            // If user is logged in
            let user = Auth.auth().currentUser
            if let user = user {
                // Set the value of coin to the database
                self.ref.child("users").child((user.uid)).child("Coins").setValue(String(money))
                
                // If totalScore is bigger than the previous high score
                if totalScore > high{
                    self.ref.child("users").child((user.uid)).child("High").setValue(String(totalScore))
                }
            }
            // End of google firebase code
            
            // If totalScore is bigger than the previous high score
            if totalScore > high{
                UserDefaults.standard.set(totalScore , forKey:"high")
                // Request for the gps to get the users location
                location.requestLocation()
            }
        }
    }
    
    // Run if user taps the power save button
    @IBAction func powerSave(_ sender: Any) {
        if toggle == true{
            // Set the screen brightness to the current brightness
            UIScreen.main.brightness = currentBrightness
            toggle = false
        }else{
            // Set the brightness to 0.1%
            UIScreen.main.brightness = CGFloat(0.1)
            toggle = true
        }
    }
    
    // Run if the app has been closed
    @objc func appMovedToBackground() {
        // Stop the timer
        timer.invalidate()
        // Create an alert if the user comes back to the app to tell them they left the app and why it took them to the homescreen
        let alert = UIAlertController(title: "Productivity Stopped", message: "You Got Distracted By Your Phone So Disturb Has Taken You To The Home Screen", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in self.appSegueMovedToBackground()}))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Run if the app has been closed
    @objc func appSegueMovedToBackground() {
        // Stop the timer
        timer.invalidate()
        // Mins equel to 1500
        Mins = 1500
        totalScore = 0
        countUp = 0
        // Take user to the home screen
        self.performSegue(withIdentifier: "back", sender: self)
        // Set the users screen brightness to what they set it as before
        UIScreen.main.brightness = currentBrightness
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    // Run if user taps the exit button
    @IBAction func exit(_ sender: Any) {
        // Present a dialog which asks the user if they want to leave the application
        let alert = UIAlertController(title: "Disturb", message: "Are you sure you want to stop being productive? Your progress will be lost!", preferredStyle: UIAlertControllerStyle.alert)
     
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.cancel, handler: { action in self.appSegueMovedToBackground()} ))
        alert.addAction(UIAlertAction(title: "Keep Going", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Runs when ever the location is needed
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Set the longitude and latitude values into the users local storage
        UserDefaults.standard.set(userLocation.coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(userLocation.coordinate.longitude, forKey: "longitude")
        
        //Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
        
        // If user is logged in then send these values to the database
        let user = Auth.auth().currentUser
        if let user = user {
            self.ref.child("users").child((user.uid)).child("Latitude").setValue(String(userLocation.coordinate.latitude))
            self.ref.child("users").child((user.uid)).child("Longitude").setValue(String(userLocation.coordinate.longitude))
        }
        // End of google firebase code
    }
    
    // Run if there has been an error getting location and print it to the logs
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
