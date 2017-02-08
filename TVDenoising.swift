//
//  TVDenoising.swift
//  InertiaNav
//
//  Created by Alex Gubbay on 21/11/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation


class TVDenoising: FilteringProtocol{
    
    var proceccedPoint = 0
    var currentPoint = 0
    var k = 0
    var kZero = 0
    var kMinus = 0
    var kPlus = 0
    var vMin = 0.0
    var vMax = 0.0
    var uMin = 0.0
    var uMax = 0.0
    var lambda = 0.0
    var id = 0
    var params = [String:Double]()
    var filterName = "High Pass"
    var observers: [([accelPoint]) -> Void]
    
    var update: (([accelPoint])->Void)?
    var input = [accelPoint]()
    var output = [accelPoint]()
    let backgroundQueue = DispatchQueue(label: "com.app.queue",
                                        qos: .background,
                                        target: nil)
    
    let semaphore = DispatchSemaphore(value: 0)
    
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        if input.count == 0{
            denoise(inputData: [dataPoint])
        }else{
        addDataPointsGroup(points: [dataPoint])
        }
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    }
    func notifyObservers(data: [accelPoint]) {
        
        for i in observers {
            i(data)
        }
    }

    init(){
        observers = []
        params["lambda"] = 0.5

        
    }
    
    func addDataPointsGroup(points: [accelPoint]){

        currentPoint = output.count
        
        
        for point in points{
            let point1 = accelPoint(dataX: point.x, dataY: point.y, dataZ: point.z, count: point.count)
            output.append(point1)
            let point2 = accelPoint(dataX: point.x, dataY: point.y, dataZ: point.z, count: point.count)
            input.append(point2)
        }
        
        semaphore.signal()
        
    }
    
    func setOuputPoint(position: Int, data: Double){
        
        
        if(position > proceccedPoint){
            proceccedPoint = position
        }
         output[position].x = data
     
    }
    
    func outputData(data: [accelPoint]){
        
        for d in data{
           // print(d.x)
        }
    }

    
    func denoise(inputData: [accelPoint]){
        self.input = inputData
        self.output = inputData
        
        vMin = abs(input[0].x) - lambda
        vMax = abs(input[0].x) + lambda
        uMin = lambda
        uMax = -lambda
        
        backgroundQueue.async {
            
            outerLoop: while true {
                
                
                ifState: if self.proceccedPoint >= self.input.count - 1{
                    
                    self.semaphore.wait()
                    
                    
                }else{
                    
                    innerLoop: while true {
                        
                        
                        while self.k+1 < self.input.count-1{
                            
                            //LINE 2
                            
                            if(self.k == self.input.count-1){
                                //output[input.count-1].setProcessed(data:(vMin + uMax))
                                self.setOuputPoint(position: self.input.count-1, data: (self.vMin + self.uMax))
                                //print(output.suffix(from: 0))
                                
                                
                                self.update!(Array(self.output.suffix(from: self.currentPoint)))
                                self.semaphore.signal()
                                break ifState
                                //return output
                            }
                            
                            
                            //LINE 3
                            
                            if(abs(self.input[self.k+1].x) + self.uMin < self.vMin - self.lambda){
                                
                                for i in self.kZero ... self.kMinus{
                                    //output[i].setProcessed(data: vMin)
                                    self.setOuputPoint(position: i, data: self.vMin)
                                }
                                
                                self.k = self.kMinus + 1
                                self.kZero = self.kMinus + 1
                                self.kMinus = self.kMinus + 1
                                self.kPlus = self.kMinus + 1
                                
                                self.vMin = abs(self.input[self.k].x)
                                self.vMax = abs(self.input[self.k].x) + 2 * self.lambda
                                
                                self.uMin = self.lambda
                                self.uMax = -self.lambda
                                
                                //LINE 4
                                
                            }else if abs(self.input[self.k+1].x) + self.uMax > self.vMax + self.lambda {
                                
                                for i in self.kZero ... self.kPlus{
                                    //output[i].setProcessed(data: vMax)
                                    self.setOuputPoint(position: i, data: self.vMax)
                                }
                                
                                self.k = self.kPlus + 1
                                self.kZero = self.kPlus + 1
                                self.kMinus = self.kPlus + 1
                                self.kPlus = self.kPlus + 1
                                
                                self.vMin = abs(self.input[self.k].x) - 2 * self.lambda
                                self.vMax = abs(self.input[self.k].x)
                                self.uMin = self.lambda
                                self.uMax = -self.lambda
                                
                                //LINE 5
                                
                            }else{
                                
                                self.k = self.k + 1
                                self.uMin = self.uMin + abs(self.input[self.k].x) - self.vMin
                                self.uMax = self.uMax + abs(self.input[self.k].x) - self.vMax
                                
                                //LINE 6 PART ONE & PART 2
                                
                                if self.uMin >= self.lambda {
                                    
                                    self.vMin = self.vMin + (self.uMin - self.lambda)/Double(self.k - self.kZero + 1)
                                    self.uMin = self.lambda
                                    self.kMinus = self.k
                                    
                                }
                                
                                if self.uMax <= -self.lambda {
                                    
                                    self.vMax = self.vMax + (self.uMax + self.lambda)/Double(self.k - self.kZero + 1)
                                    self.uMax = -self.lambda
                                    self.kPlus = self.k
                                    
                                }
                            }
                        }
                        
                        //LINE 8
                        
                        if self.uMin < 0 {
                            
                            for i in self.kZero ... self.kMinus{
                                //output[i].setProcessed(data: vMin)
                                self.setOuputPoint(position: i, data: self.vMin)
                            }
                            
                            self.k = self.kMinus + 1
                            self.kZero = self.kMinus + 1
                            self.kMinus = self.kMinus + 1
                            
                            self.vMin = abs(self.input[self.k].x)
                            self.uMin = self.lambda
                            self.uMax = abs(self.input[self.k].x) + self.lambda - self.vMax
                            
                            //break
                            
                            //LINE 9
                            
                        }else if self.uMax > 0 {
                            
                            for i in self.kZero ... self.kPlus{
                                
                                //output[i].setProcessed(data: vMax)
                                self.setOuputPoint(position: i, data: self.vMax)
                                
                            }
                            
                            self.k = self.kPlus + 1
                            self.kZero = self.kPlus + 1
                            self.kPlus = self.kPlus + 1
                            
                            self.vMax = abs(self.input[self.k].x)
                            self.uMax = -self.lambda
                            self.uMin = abs(self.input[self.k].x) - self.lambda - self.vMin
                            
                            //break
                            
                        }else{
                            break innerLoop
                        }
                    }
                    
                    //LINE 10
                    
                    for i in self.kZero ... self.output.count - 1{
                        //output[i].setProcessed(data: (vMin + uMin)/Double(k - kZero + 1))
                        let data = (self.vMin + self.uMin)/Double(self.k - self.kZero + 1)
                        self.setOuputPoint(position: i, data: data)
                        
                    }
                    self.notifyObservers(data:Array(self.output.suffix(from: self.currentPoint)))
                    self.semaphore.signal()
                    //return output
                }
            }
        }
    }
}
