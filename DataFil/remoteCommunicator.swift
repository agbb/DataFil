//
//  watchCommunicator.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation
import WatchConnectivity


class remoteCommunicator: NSObject, WCSessionDelegate {

    static let sharedInstance = remoteCommunicator()
    var watchObservers: [String: [(Any) -> Void]]
    var delegates = [AnyObject]()
    var session: WCSession?
    var deviceId = "unknown"

    func start(deviceId: String){
        self.deviceId = deviceId
        if WCSession.isSupported() {
            WCSession.default().delegate = self
            WCSession.default().activate()
            print("comms live on \(deviceId)")

        }else{
            print("unable to enable coms on \(deviceId)")
        }
    }
    override init(){

        watchObservers = [:]
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?){
    }

    #if os(iOS)
    func sessionDidDeactivate(_ session: WCSession) {
        //ERM
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        //Do some stuff here I gueess
    }
    #endif
    public func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        //
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

        for k in message.keys{
            notifyObservers(key: k, data: message[k] as Any)
        }
    }

    func sendMessage(key: String, value: Any){

        if (WCSession.default().isReachable) {
            let message = [key: value]
            WCSession.default().sendMessage(message, replyHandler: nil)
        }else{
            print("remote unreachable from \(deviceId)")
        }
    }

    func addObserver(key: String, update: @escaping (Any) -> Void) {
        DispatchQueue.main.async {
            if var value = self.watchObservers[key]{
                value.append(update)
            }else{
                self.watchObservers[key] = [update]
            }
        }
    }

    func notifyObservers(key: String, data: Any) {

        if let registeredObservers = watchObservers[key]{

            for i in registeredObservers {
                i(data)
            }
        }
    }
}
