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
    
    func initaliseAccelerometer(){
        
        print("init")
        if manager.isAccelerometerAvailable{
            
            if manager.isAccelerometerActive == false{
                
                manager.accelerometerUpdateInterval = 1.0/100.0
                
            }else{
                print("accelerometer busy")
            }
        }
        
        if manager.isGyroAvailable {
            
            if manager.isGyroActive == false {
                
                //manager.gyroUpdateInterval = 0.001
                
                manager.startAccelerometerUpdates(to: queue,
                                                  withHandler: {data, error in
                                                    
                                                    guard data != nil else{
                                                        return
                                                    }
                                
                                                    let accel = accelPoint(dataX: (data?.acceleration.x)!, dataY:(data?.acceleration.y)!, dataZ:(data?.acceleration.z)!)
                                                    self.notify(accel: accel)
                                                    
                                                })
            } else {
                print("Gyro is already active")
            }
            
        } else {
            print("Gyro isn't available")
        }
    }
    
    func notify(accel: accelPoint){
        notificationManager.nc.post(name: notificationManager.newRawDataNotification, object: nil, userInfo:["data":accel])

    }
}




