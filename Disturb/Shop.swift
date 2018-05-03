//
//  Shop.swift
//  Disturb
//
//  Created by Scott Andrews on 23/12/2017.
//  Copyright © 2017 Scott Andrews. All rights reserved.
//

// Makes frameworks avaliable in the swift document
import UIKit
import FirebaseDatabase
import FirebaseAuth

class Shop: UIViewController{
    
    var ref: DatabaseReference!
    
    // creates a varible that holds the label values into variables
    @IBOutlet weak var coins: UILabel!
    
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var levelUpButton: UIButton!
    
    // Set a variable to money of type integer
    var money = UserDefaults.standard.integer(forKey: "coin")
    
    // Run on view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        // Run function updateLabel
        updateLabel()
        
        // If the user has purchased the black ball then set the black button to have a background colour of black
        if UserDefaults.standard.value(forKey: "black") != nil{
            blackButton.backgroundColor = UIColor.black
        }
        
        if UserDefaults.standard.value(forKey: "red") != nil{
            redButton.backgroundColor = UIColor.red
        }
        
        if UserDefaults.standard.value(forKey: "green") != nil{
            greenButton.backgroundColor = UIColor.green
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // If the black button has been pressed
    @IBAction func black(_ sender: Any) {
        // If the user has purchased black
        if UserDefaults.standard.value(forKey: "black") != nil{
            // Alert the user they have already purchased the black ball
            let alert = UIAlertController(title: "Disturb", message: "Already Purchased Black", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            // If they havent purchased the black ball
            // Alert the user do they want to buy the ball with an alert box with the option to buy or cancel
            let alert = UIAlertController(title: "Disturb", message: "Do You Want To Buy The Black Circle For 10 Coins?", preferredStyle: UIAlertControllerStyle.alert)
            
            // If pressed then run the function black
            alert.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.cancel, handler: { action in self.black()}))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            // If user is logged in then set a value of Black to the users database
            let user = Auth.auth().currentUser
            if let user = user {
                self.ref.child("users").child((user.uid)).child("Black").setValue("Black")
            }
            // End of google firebase code
        }
        
    }
    
    func black(){
        // If money is more than 10 coins
        if money >= 10{
            // Set background colour of button to black
            blackButton.backgroundColor = UIColor.black
            // Deduct 10 coins from money
            money = money - 10
            // Run updateLabel and updateMoney
            updateLabel()
            updateMoney()
            // Set local storage to black
            UserDefaults.standard.set("black" , forKey:"black")
            
        }else{
            // If the user does not have enough money then alert them that they have not
            let alert = UIAlertController(title: "Disturb", message: "Not Enough Coins", preferredStyle: UIAlertControllerStyle.alert)
    
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // Red Circle
    @IBAction func red(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "red") != nil{
            let alert = UIAlertController(title: "Disturb", message: "Already Purchased Red", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Disturb", message: "Do You Want To Buy The Red Circle For 10 Coins?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.cancel, handler: { action in self.red()}))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            let user = Auth.auth().currentUser
            if let user = user {
                self.ref.child("users").child((user.uid)).child("Red").setValue("Red")
            }
            // End of google firebase code
        }
    }
    
    func red(){
        if money >= 10{
            redButton.backgroundColor = UIColor.red
            money = money - 10
            updateLabel()
            updateMoney()
            UserDefaults.standard.set("red" , forKey:"red")
            
        }else{
            let alert = UIAlertController(title: "Disturb", message: "Not Enough Coins", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // Green Circle
    @IBAction func green(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "green") != nil{
            let alert = UIAlertController(title: "Disturb", message: "Already Purchased Green", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Disturb", message: "Do You Want To Buy The Green Circle For 10 Coins?", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.cancel, handler: { action in self.green()}))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            let user = Auth.auth().currentUser
            if let user = user {
                self.ref.child("users").child((user.uid)).child("Green").setValue("Green")
            }
            // End of google firebase code
        }
    }
    
    func green(){
        if money >= 10{
            greenButton.backgroundColor = UIColor.green
            money = money - 10
            updateLabel()
            updateMoney()
            UserDefaults.standard.set("green" , forKey:"green")
            
        }else{
            let alert = UIAlertController(title: "Disturb", message: "Not Enough Coins", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // Run if the user choses to press the level up button
    @IBAction func levelUp(_ sender: Any) {
        // Create an alert that asks the user if they want to buy a level
        let alert = UIAlertController(title: "Disturb", message: "Do You Want To Buy One Level Up For 10 Coins?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Buy", style: UIAlertActionStyle.cancel, handler: { action in self.addLevel()}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Run if user presses the buy button on the level up button
    func addLevel(){
        // Checks to make sure that the user has more than or equel to 10 coins
        if money >= 10{
            // Take away the 10 coins from the user
            money = money - 10
            // Update the coin label on screen
            updateLabel()
            // Update the money count throughout the whole app
            updateMoney()
            // Get the users current level
            var level = UserDefaults.standard.integer(forKey: "broughtTime")
            // Add 3600 seconds to it which is equel to an hour
            level = level + 3600
            // Set the new value of level into local storage
            UserDefaults.standard.set(level, forKey: "broughtTime")
            
            // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
            let user = Auth.auth().currentUser
            // If user logged in then run
            if let user = user {
                self.ref.child("users").child((user.uid)).child("BroughtTime").setValue(String(level))
            }
            // End of google firebase code
        }else{
            // Run if money is less than 10 and the user does not have the coins to purchase
            let alert = UIAlertController(title: "Disturb", message: "Not Enough Coins", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateLabel(){
        // Updates the coins label
        coins.text = "Coins: " + String(money)
    }
    
    func updateMoney(){
        // Sets the new value of money to local storage
        UserDefaults.standard.set(money , forKey:"coin")
        
        // Firebase. (2018). Add Firebase to your iOS Project  |  Firebase. [online] Available at: https://firebase.google.com/docs/ios/setup [Accessed 23 Apr. 2018].
        let user = Auth.auth().currentUser
        // Run if user is logged in
        if let user = user {
            self.ref.child("users").child((user.uid)).child("Coins").setValue(String(money))
        }
        //  End of google firebase code
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
