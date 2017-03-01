//
//  accelerometerManager.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 08/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation
import CoreMotion



class accelerometerManager{
    
    lazy var manager = CMMotionManager()
    lazy var queue = OperationQueue()
    var count = 0
    var sampleRate = 30.0
    
    init(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.newDatasourceSettings), name: Notification.Name("newDatasourceSettings"), object: nil)
    }
    func initaliseAccelerometer(){
        
        if manager.isAccelerometerAvailable{
            if manager.isAccelerometerActive == false{
                manager.accelerometerUpdateInterval = 1.0/sampleRate
            }else{
                print("accelerometer busy")
            }
        }
        if manager.isGyroAvailable {
            if manager.isGyroActive == false {
                manager.startAccelerometerUpdates(to: queue,
                    withHandler: {data, error in
                        guard data != nil else{
                            return
                        }
                        DispatchQueue.main.async{
                            self.count += 1
                            let accel = accelPoint(dataX: (data?.acceleration.x)!, dataY:(data?.acceleration.y)!, dataZ:(data?.acceleration.z)!, count:self.count)
                            
                            NotificationCenter.default.post(name: Notification.Name("newRawData"), object: nil, userInfo:["data":accel])
                        }
                })
            } else {
                print("Gyro is already active")
            }
        } else {
            print("Gyro isn't available")
        }
    }
    
    @objc func newDatasourceSettings(notification: NSNotification) {
        let data = notification.userInfo as! Dictionary<String,Double>
        sampleRate = data["sampleRate"]!
        print(sampleRate)
        if manager.isAccelerometerAvailable{
            if manager.isAccelerometerActive != false{
                manager.accelerometerUpdateInterval = 1.0/sampleRate
            }else{
                print("accelerometer not active")
            }
        }
    }
    
}




