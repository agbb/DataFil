//
//  accelerometerManager.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 08/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import Foundation
import CoreMotion
/*
 Responsible for creating data objects from the system sensor outputs. Publically broadcasts them via notification.
 */
class DataSourceManager{

    lazy var manager = CMMotionManager()
    lazy var queue = OperationQueue()
    var count = 0
    var sampleRate = 30.0
    var sourceId = ""
    var gyroSelected = true
    var magSelected = true
    var accelSelcted = true
    init(sourceId: String){
        self.sourceId = sourceId
        NotificationCenter.default.addObserver(self, selector: #selector(self.newDatasourceSettings), name: Notification.Name("newDatasourceSettings"), object: nil)
    }
    /**
     Starts the data sources up and when ready begins broadcasting data objects via the `newRawData` notification.
     */
    func initaliseDatasources(){
        print("hello")
        if manager.isGyroAvailable && gyroSelected{
            if manager.isGyroActive == false{
                manager.gyroUpdateInterval = 1.0/sampleRate
                manager.startGyroUpdates()
            }
        }
        if manager.isMagnetometerAvailable{
            if manager.isMagnetometerActive == false{
                manager.magnetometerUpdateInterval = 1.0/sampleRate
                manager.startMagnetometerUpdates()
            }
        } 
        if manager.isAccelerometerAvailable && magSelected{
            if manager.isAccelerometerActive == false{
                manager.accelerometerUpdateInterval = 1.0/sampleRate
                manager.startAccelerometerUpdates(to: queue,
                      withHandler: {data, error in
                        guard data != nil else{
                            return
                        }
                        DispatchQueue.main.async{
                            self.count += 1
                            let accel = accelPoint()
                            accel.count = self.count
                            if self.accelSelcted{
                                accel.xAccel = (data?.acceleration.x)!
                                accel.yAccel = (data?.acceleration.y)!
                                accel.zAccel = (data?.acceleration.z)!
                            }
                            if self.manager.isGyroActive {
                                let gyro = self.manager.gyroData?.rotationRate
                                if gyro?.x != nil && gyro?.y != nil && gyro?.z != nil {
                                    accel.xGyro = (self.manager.gyroData?.rotationRate.x)!
                                    accel.yGyro = (self.manager.gyroData?.rotationRate.y)!
                                    accel.zGyro = (self.manager.gyroData?.rotationRate.z)!
                                }else{
                                    accel.xGyro = 0.0
                                    accel.yGyro = 0.0
                                    accel.zGyro = 0.0
                                }
                            }
                            if self.manager.isMagnetometerActive{
                                let mag = self.manager.magnetometerData?.magneticField
                                if mag?.x != nil && mag?.y != nil && mag?.z != nil{
                                    accel.xMag = (self.manager.magnetometerData?.magneticField.x)!
                                    accel.yMag = (self.manager.magnetometerData?.magneticField.y)!
                                    accel.zMag = (self.manager.magnetometerData?.magneticField.z)!
                                }else{
                                    accel.xGyro = 0.0
                                    accel.yGyro = 0.0
                                    accel.zGyro = 0.0
                                }
                            }
                            NotificationCenter.default.post(name: Notification.Name("newRawData"), object: nil, userInfo:["data":accel])
                        }
                })
            }else{
                print("accelerometer busy")
            }
        }
    }

    /**
     Shuts down data sources. Use to conserve power.
    */
    func deinitDatasources(){
        manager.stopAccelerometerUpdates()
        manager.startGyroUpdates()
        manager.startMagnetometerUpdates()
    }
    /**
     Nominated by the observer to be called when notified of new settings for data sources. Called when a notification with the format ["sampleRate":Double] and the name "newDataSourceSettings" is posted to update the sample rate of the sensors.
     */
    @objc func newDatasourceSettings(notification: NSNotification) {
        let data = notification.userInfo as! Dictionary<String,Double>
        sampleRate = data["sampleRate"]!
        if manager.isAccelerometerAvailable{
            if manager.isAccelerometerActive != false{
                print("notified \(sampleRate)")
                manager.accelerometerUpdateInterval = 1.0/sampleRate
            }else{
                print("accelerometer not active")
            }
        }
    }
}
