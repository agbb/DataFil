//
//  InterfaceController.swift
//  WatchDataFil Extension
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    var active = false
    let accel = accelerometerManager.init(sourceId: "watch")

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
    }
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var infoLabel: WKInterfaceLabel!

    @IBAction func startButtonPressed() {

        if !active{
            remoteCommunicator.sharedInstance.start(deviceId: "watch")

            accel.initaliseDatasources()
            remoteDataInterface.sharedInstance.publishOutgoingData()
            startButton.setTitle("Stop")
            active = true
        }else{
            accel.initaliseDatasources()
            startButton.setTitle("Start")
            active = false
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
