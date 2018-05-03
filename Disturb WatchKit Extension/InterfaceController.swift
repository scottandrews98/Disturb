//
//  InterfaceController.swift
//  Disturb WatchKit Extension
//
//  Created by Scott Andrews on 10/12/2017.
//  Copyright © 2017 Scott Andrews. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    @IBOutlet var totalCoins: WKInterfaceButton!
    @IBOutlet var highScore: WKInterfaceButton!
    @IBOutlet var mapView: WKInterfaceMap!
    @IBOutlet var openDisturb: WKInterfaceLabel!
    
    var number = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        showTest()
        totalCoins.setHidden(false)
        highScore.setHidden(false)
        mapView.setHidden(false)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        showTest()

        let session = WCSession.default
        session.delegate = self
        session.activate()
   
        
        
    }
    
    func showTest(){
        if number == 0 {
            totalCoins.setHidden(true)
            highScore.setHidden(true)
            mapView.setHidden(true)
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo applicationDic: [String : Any] = [:]) {
        let coin = applicationDic["coin"]
        let high = applicationDic["high"]
        totalCoins.setTitle("Total Coins: \(String(describing: coin!))")
        highScore.setTitle("High Score: \(String(describing: high!))")
        number = 1
        
        let lattiude1 = applicationDic["lattitude"]
        let longitude1 = applicationDic["longitude"]
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(lattiude1 as! CLLocationDegrees, longitude1 as! CLLocationDegrees), span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.5), longitudeDelta: CLLocationDegrees(0.5))))
        
        mapView.addAnnotation(CLLocationCoordinate2D(latitude:lattiude1 as! CLLocationDegrees, longitude: longitude1 as! CLLocationDegrees), with: WKInterfaceMapPinColor.green)
        
        totalCoins.setHidden(false)
        highScore.setHidden(false)
        mapView.setHidden(false)
        openDisturb.setHidden(true)
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
