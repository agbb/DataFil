//
//  advancedLowPass.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 20/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation

class advancedLowPass: FilteringProtocol {
    
    var params = [String:Double]()
    var filterName = "Low Pass"
    var observers: [([accelPoint]) -> Void]
    var rawMinusOne: accelPoint
    var rawMinusTwo: accelPoint
    var processedMinusOne: accelPoint
    var processedMinusTwo: accelPoint
    var id = 0
    var c = 0.0, fStar = 0.0, w0 = 0.0, k1 = 0.0, k2 = 0.0, a0 = 0.0, a1 = 0.0, a2 = 0.0, b1 = 0.0, b2 = 0.0
    
    init(){
        
        self.rawMinusOne = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        self.rawMinusTwo = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        self.processedMinusOne = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        self.processedMinusTwo = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        observers = []
        params["p"] = sqrt(2.0)
        params["g"] = 1.0
        params["n"] = 1.0
        params["fs"] = 10
        params["f0"] = 0.1
        calculateCoeffcients()
    }
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
        calculateCoeffcients()
    }
    
    private func calculateCoeffcients(){
        
        let n = params["n"]!
        let p = params["p"]!
        let g = params["g"]!
        
        c = (2.0^^(1/n)-1.0)^^(-0.25)
        c = 0.7344009
        fStar = c * params["f0"]! / params["fs"]!
        
        if(fStar < 0 || fStar > 0.125 ){
            print("WARNING: Invalid value for fStar coefficient")
        }
        
        w0 = tan(Double.pi*c*params["f0"]!)
        k1 = p * w0
        k2 = g * w0^^2.0
        a0 = k2/(1.0 + k1 + k2)
        a1 = 2.0 * a0
        a2 = a0
        b1 = 2.0 * a0 * (1.0 / k2 - 1.0)
        b2 = 1.0 - (a0 + a1 + a2 + b1)
        print("coeffecients calulated")
        print(a0)
        print(a1)
        print(a2)
        print()
        print()
        
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {

        lowPass(currentRaw: dataPoint)
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    }
    func notifyObservers(data: [accelPoint]) {
        for i in observers {
            i(data)
        }
    }
    
    func lowPass(currentRaw: accelPoint){

        let xCurrentProcessed = a0 * currentRaw.x + a1 * rawMinusOne.x + a2 * rawMinusTwo.x + b1 * processedMinusOne.x + b2 * processedMinusTwo.x

        
        let yCurrentProcessed = a0 * currentRaw.y + a1 * rawMinusOne.y + a2 * rawMinusTwo.y + b1 * processedMinusOne.y + b2 * processedMinusTwo.y
        
        let zCurrentProcessed = a0 * currentRaw.z + a1 * rawMinusOne.z + a2 * rawMinusTwo.z + b1 * processedMinusOne.z + b2 * processedMinusTwo.z
        
        
        
        rawMinusTwo = accelPoint(dataX:rawMinusOne.x, dataY:rawMinusOne.y, dataZ:rawMinusOne.z, count : currentRaw.count)
        rawMinusOne = accelPoint(dataX:currentRaw.x, dataY:currentRaw.y, dataZ:currentRaw.z, count : currentRaw.count)
        
        let newPoint = accelPoint(dataX:xCurrentProcessed, dataY:yCurrentProcessed, dataZ:zCurrentProcessed, count : currentRaw.count)
        
        processedMinusTwo = accelPoint(
            dataX:processedMinusOne.x,dataY:processedMinusOne.y, dataZ: processedMinusOne.z, count:currentRaw.count)
        processedMinusOne = accelPoint(
            dataX:xCurrentProcessed, dataY:yCurrentProcessed, dataZ:zCurrentProcessed, count : currentRaw.count)

        notifyObservers(data: [newPoint])
    }
    
}