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


    let comms = deviceCommunicator.sharedInstance

    @IBAction func buttonTapped() {

        comms.sendMessage(key: "Hello", value: "bye")
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        print("starting")
        comms.start()
        // Configure interface objects here.
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
