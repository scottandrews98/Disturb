//
//  Statistics.swift
//  Disturb
//
//  Created by Scott Andrews on 30/12/2017.
//  Copyright © 2017 Scott Andrews. All rights reserved.
//

// Makes frameworks avaliable in the swift document
import UIKit
import MapKit

class Statistics: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var longestStreak: UILabel!
    
    @IBOutlet weak var totalTime: UILabel!
    
    // Runs when the view controller has loaded
    override func viewDidLoad() {
        super.viewDidLoad()
     }
    
    // Runs when the view controller has been loaded
    override func viewDidAppear(_ animated: Bool) {
        // Sets a constant for the amount of zoom applied to the map view
        let zoom:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        
        // If there is a latitude value saved
        if UserDefaults.standard.value(forKey: "latitude") != nil {
            // Set a value of latitude to a constant
            let latiudeReal =  UserDefaults.standard.double(forKey: "latitude")
            
            // If latitude equels 0.0 then run alert function
            if  latiudeReal == 0.0 {
                alert()
            }else{
                // Get the current lattitude and longitude values from the local storage
                let lattiude = UserDefaults.standard.double(forKey: "latitude")
                let longitude = UserDefaults.standard.double(forKey: "longitude")
                
                // Create map cordninates with constants above
                let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lattiude , longitude )
                
                // Creat a map area from th eocrndinates and zoom value
                let region:MKCoordinateRegion = MKCoordinateRegionMake(location, zoom)
                
                // Set the ma[ view with the region declared
                mapView.setRegion(region, animated: true)
                
                // Declare an anotation
                let annotation = MKPointAnnotation()
                // Declare the location the annotation should go
                annotation.coordinate = location
                // Give annotation a title
                annotation.title = "Highest Score Location"
                // Give annotation a subtitle
                annotation.subtitle = "The location you achieved your highest score."
                // Add annotation to the map
                mapView.addAnnotation(annotation)
                
                // Send map to back
                self.view.sendSubview(toBack: mapView)
                
                // If there is a value of high score saved in the local storage
                if UserDefaults.standard.value(forKey: "high") != nil {
                    longestStreak.text = String(describing: UserDefaults.standard.value(forKey: "high")!)
                }
            }
        }
        
        // Run if total time is not empty
        if UserDefaults.standard.value(forKey: "totalTime") != nil {
            let time = UserDefaults.standard.integer(forKey: "totalTime")
            let hoursLeft = Int(time) / 3600
            let minutesLeft = Int(time) / 60 % 60
            let secondsLeft = Int(time) % 60
            
            // If seconds left is less than 10 then place a zero on seconds
            if secondsLeft < 10 {
                totalTime.text = "Hr: \(hoursLeft) Min: \(minutesLeft) Sec: 0\(secondsLeft)"
            }else{
                totalTime.text = "Hr: \(hoursLeft) Min: \(minutesLeft) Sec: \(secondsLeft)"
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert(){
        // Display an alert to tell the user that they have not enabled location services
        let alert = UIAlertController(title: "Error Getting Location", message: "Make Sure You've Allowed Location Services", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
