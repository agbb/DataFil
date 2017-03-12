//
//  deviceCommunicator.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation
import WatchConnectivity
import WatchKit

class deviceCommunicator: NSObject, WCSessionDelegate {

    static let sharedInstance = deviceCommunicator()
    let session = WCSession.default()

    func start() {

        session.delegate = self
        session.activate()
    }

    override init(){
        print("comms live on watch")
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("\(message.keys.first) from device > watch")
        WKInterfaceDevice().play(.click)
    }

    func sendMessage(key: String, value: Any){

        if (WCSession.default().isReachable) {
            // this is a meaningless message, but it's enough for our purposes
            let message = [key: value]
            WCSession.default().sendMessage(message, replyHandler: nil)
        }
        
    }

}
