//
//  dataPackager.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

class remoteDataInterface {

    static let sharedInstance = remoteDataInterface()
    let srl = serialiser()
    let observerKey = "watchAccelRaw"
    var buffer = [String]()
    var isListening = false
    var isSending = false

    func publishOutgoingData(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.newOutgoingData), name: Notification.Name("newRawData"), object: nil)
    }

    func subscribeIncomingData() {

        let incoming = {(data: Any)->Void in

            for d in data as! [String]{
                let accel = self.srl.deserialise(input: d)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("newRemoteData"), object: nil, userInfo:["data":accel])
                }

            }
        }

        remoteCommunicator.sharedInstance.addObserver(key: observerKey, update: incoming)
        isListening = true
    }

    func teardown(){
        
         NotificationCenter.default.removeObserver(self)
        isListening = false
        isSending = false
        
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }

    @objc private func newOutgoingData(notification: NSNotification){
        let data = notification.userInfo as! Dictionary<String,accelPoint>

        if let accelData = data["data"]{
            buffer.append(srl.serialise(input: accelData))
        }

        if buffer.count > 30 {
            remoteCommunicator.sharedInstance.sendMessage(key: "watchAccelRaw", value: buffer)
            buffer.removeAll()
        }
        isSending = true
    }

}
