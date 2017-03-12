//
//  MainInterfaceController.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class MainInterfaceController: WKInterfaceController{

    @IBOutlet var xAccelLabel: WKInterfaceLabel!
    @IBOutlet var yAccelLabel: WKInterfaceLabel!
    @IBOutlet var zAccelLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        print("starting")
       
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
       // NotificationCenter.default.addObserver(self, selector: #selector(self.newRawData), name: Notification.Name("newRawData"), object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(self.newProcessedData), name: Notification.Name("newProcessedData"), object: nil) 
    }

    func newRawData(notification: NSNotification){
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]!
        xAccelLabel.setText("\(Double(accelData.x).roundTo(places: 4))")
        yAccelLabel.setText("\(Double(accelData.y).roundTo(places: 4))")
        zAccelLabel.setText("\(Double(accelData.z).roundTo(places: 4))")

    }

    /*func newProcessedData(notification: NSNotification){

        let data = notification.userInfo as! Dictionary<String,[accelPoint]>
        let accelDataArray = data["data"]

        for accelData in accelDataArray!{

        }
    } */

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
