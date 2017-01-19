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
    func initaliseAccelerometer(){
        
        if manager.isAccelerometerAvailable{
            
            if manager.isAccelerometerActive == false{
                
                manager.accelerometerUpdateInterval = 1.0/10.0
                
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
                                                    self.count += 1
                                                   
                                                   
                                                    DispatchQueue.main.async{
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

}




