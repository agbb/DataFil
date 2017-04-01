//
//  boundedAverage.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 25/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

class boundedAverage: Filter {
    
    
    var params = [String:Double]()
    var filterName = "Bounded Average"
    var observers: [([accelPoint]) -> Void]
    var id = 0
    var currentCenterX = 0.0
    var currentCenterY = 0.0
    var currentCenterZ = 0.0
    var inital = true
    var xAvg = 0.0
    var yAvg = 0.0
    var zAvg = 0.0
    var currentAvg = accelPoint.init(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
    
    init(){
        params["upperBound"] = 0.1
        params["lowerBound"] = 0.1
        params["points"] = 1
        observers = []
        
    }
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        let averagePoint = movingAverage(dataPoint: dataPoint)
        boundedAverage(currentRaw: averagePoint)
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    
    }
    
    func notifyObservers(data: [accelPoint]) {
        for i in observers {
            i(data)
        }
    }
    
    func movingAverage(dataPoint:accelPoint)->accelPoint{
        let points = (Double(params["points"]!).roundTo(places: 0))
        
        if points > 1.0 {
            xAvg = xAvg + (dataPoint.xAccel - xAvg) / Double(dataPoint.count+1)
            yAvg = yAvg + (dataPoint.yAccel - yAvg) / Double(dataPoint.count+1)
            zAvg = zAvg + (dataPoint.zAccel - zAvg) / Double(dataPoint.count+1)
            let newPoint = accelPoint(dataX: xAvg, dataY: yAvg, dataZ: zAvg, count: dataPoint.count)
            return newPoint
        }else{
            return dataPoint
        }
    }
    
    func boundedAverage(currentRaw: accelPoint){
        var newPoint = accelPoint()
        newPoint.count = currentRaw.count
        if currentRaw.xAccel > (currentCenterX + params["upperBound"]!){
            currentCenterX = currentRaw.xAccel
            newPoint.xAccel = currentCenterX
        }else if currentRaw.xAccel < (currentCenterX - params["lowerBound"]!){
            currentCenterX = currentRaw.xAccel
            newPoint.xAccel = currentCenterX
        }else{
            newPoint.xAccel = currentCenterX
        }
        if currentRaw.yAccel > (currentCenterY + params["upperBound"]!){
            currentCenterY = currentRaw.yAccel
            newPoint.yAccel = currentCenterY
        }else if currentRaw.yAccel < (currentCenterY - params["lowerBound"]!){
            currentCenterY = currentRaw.yAccel
            newPoint.yAccel = currentCenterY
        }else{
            newPoint.yAccel = currentCenterY
        }
        if currentRaw.zAccel > (currentCenterZ + params["upperBound"]!){
            currentCenterZ = currentRaw.zAccel
            newPoint.zAccel = currentCenterZ
        }else if currentRaw.zAccel < (currentCenterZ - params["lowerBound"]!){
            currentCenterZ = currentRaw.zAccel
            newPoint.zAccel = currentCenterZ
        }else{
            newPoint.zAccel = currentCenterZ
        }
        notifyObservers(data: [newPoint])
    }
}
