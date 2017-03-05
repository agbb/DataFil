//
//  HighPass.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 08/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation

class HighPass: FilteringProtocol{
    
    var params = [String:Double]()
    var filterName = "High Pass"
    var observers: [([accelPoint]) -> Void]
    var previousValue: accelPoint
    var previousRaw: accelPoint
    var sampleGap = 0.0
    var cutoff = 0.0
    var filterVal = 0.0
    var id = 0
    
    init(){

        params["sampleRate"] = 30.0
        params["cutoffFrequency"] = 40.0
        
        sampleGap = 1.0/(params["sampleRate"]!)
        cutoff = 1.0/(params["cutoffFrequency"]!)

        filterVal = cutoff/(sampleGap+cutoff)
        self.previousValue = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        self.previousRaw = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        observers = []
    }
    
    func getFilterName() -> String{
        return filterName
    }

    func setParameter(parameterName: String, parameterValue: Double) {
        
        params[parameterName] = parameterValue
        
        
        sampleGap = 1.0/(params["sampleRate"]!)
        cutoff = 1.0/(params["cutoffFrequency"]!)
        
        filterVal = cutoff/(sampleGap+cutoff)

    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        highPass(currentRaw: dataPoint)
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    }
    func notifyObservers(data: [accelPoint]) {
        for i in observers {
            i(data)
        }
    }
    
    func highPass(currentRaw: accelPoint){
        var newPoint = accelPoint()
        newPoint.x = filterVal * (previousValue.x + currentRaw.x -  previousRaw.x)
        newPoint.y = filterVal * (previousValue.y + currentRaw.y -  previousRaw.y)
        newPoint.z = filterVal * (previousValue.z + currentRaw.z -  previousRaw.z)
        
        newPoint.count = currentRaw.count
        previousValue = newPoint
        previousRaw = currentRaw
        notifyObservers(data: [newPoint])
    }
}
