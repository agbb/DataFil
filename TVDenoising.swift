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
    var lambda = 0.5
    var id = 0
    var params = [String:Double]()
    var filterName = "Total Variation Denoising"
    var observers: [([accelPoint]) -> Void]
    
    var update: (([accelPoint])->Void)?
    var input = [accelPoint]()
    var buffer = [accelPoint]()
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
        lambda = params["lambda"]!
        print(params["lambda"]!)
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        if buffer.count < Int(params["bufferSize"]!){
            buffer.append(dataPoint)
        }else{
            if input.count == 0{
                denoise(inputData: buffer)
            }else{
                addDataPoint(point: buffer)
            }
            buffer.removeAll()
        }
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    }
    func notifyObservers(data: [accelPoint]) {
        
        DispatchQueue.main.async {
            
            for i in self.observers {
                i(data)
            }
        }
        
    }

    init(){
        
        observers = []
        params["lambda"] = 0.5
        params["bufferSize"] = 100

    }
    
    func addDataPoint(point: [accelPoint]){
        
        currentPoint = output.count
        input.append(contentsOf: point)
        output.append(contentsOf: point)
        semaphore.signal()
        
    }
    
    func setOuputPoint(position: Int, data: Double){
        
        if(position > proceccedPoint){
            proceccedPoint = position
        }
        
        output[position].x = data
    }

    func denoise(inputData: [accelPoint]){
        
        self.input = inputData
        self.output = inputData
        
        vMin = input[0].getAbs() - lambda
        vMax = input[0].getAbs() + lambda
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
                            
                            if(self.input[self.k+1].getAbs() + self.uMin < self.vMin - self.lambda){
                                
                                for i in self.kZero ... self.kMinus{
                                    //output[i].setProcessed(data: vMin)
                                    self.setOuputPoint(position: i, data: self.vMin)
                                }
                                
                                self.k = self.kMinus + 1
                                self.kZero = self.kMinus + 1
                                self.kMinus = self.kMinus + 1
                                self.kPlus = self.kMinus + 1
                                
                                self.vMin = self.input[self.k].getAbs()
                                self.vMax = self.input[self.k].getAbs() + 2 * self.lambda
                                
                                self.uMin = self.lambda
                                self.uMax = -self.lambda
                                
                                //LINE 4
                                
                            }else if self.input[self.k+1].getAbs() + self.uMax > self.vMax + self.lambda {
                                
                                for i in self.kZero ... self.kPlus{
                                    //output[i].setProcessed(data: vMax)
                                    self.setOuputPoint(position: i, data: self.vMax)
                                }
                                
                                self.k = self.kPlus + 1
                                self.kZero = self.kPlus + 1
                                self.kMinus = self.kPlus + 1
                                self.kPlus = self.kPlus + 1
                                
                                self.vMin = self.input[self.k].getAbs() - 2 * self.lambda
                                self.vMax = self.input[self.k].getAbs()
                                self.uMin = self.lambda
                                self.uMax = -self.lambda
                                
                                //LINE 5
                                
                            }else{
                                
                                self.k = self.k + 1
                                self.uMin = self.uMin + self.input[self.k].getAbs() - self.vMin
                                self.uMax = self.uMax + self.input[self.k].getAbs() - self.vMax
                                
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
                            
                            self.vMin = self.input[self.k].getAbs()
                            self.uMin = self.lambda
                            self.uMax = self.input[self.k].getAbs() + self.lambda - self.vMax
                            
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
                            
                            self.vMax = self.input[self.k].getAbs()
                            self.uMax = -self.lambda
                            self.uMin = self.input[self.k].getAbs() - self.lambda - self.vMin
                            
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
                    self.notifyObservers(data: Array(self.output.suffix(from: self.currentPoint)))
                    self.semaphore.signal()
                    //return output
                }
            }
        }
    }
    
}
