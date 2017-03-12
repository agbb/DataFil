//
//  watchCommunicator.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation
import WatchConnectivity


class watchCommunicator: NSObject, WCSessionDelegate {

    static let sharedInstance = watchCommunicator()
    var delegates = [AnyObject]()
    var session: WCSession?

    func start(){

        if WCSession.isSupported() {
            WCSession.default().delegate = self
            WCSession.default().activate()
            print("comms live on device")

        }
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?){
    }

    func sessionDidDeactivate(_ session: WCSession) {
        //ERM
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        //Do some stuff here I gueess
    }

    public func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        //
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("\(message.keys.first) from watch > device")
        
    }

    func sendMessage(key: String, value: Any){

        if (WCSession.default().isReachable) {
            // this is a meaningless message, but it's enough for our purposes
            let message = [key: value]
            WCSession.default().sendMessage(message, replyHandler: nil)
        }

    }
}
