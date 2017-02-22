//
//  boundedAverage.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 25/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

class boundedAverage: FilteringProtocol {
    
    
    var params = [String:Double]()
    var filterName = "Bounded Average"
    var observers: [([accelPoint]) -> Void]
    var id = 0
    var currentCenterX = 0.0
    var currentCenterY = 0.0
    var currentCenterZ = 0.0
    var inital = true
    
    init(){
        params["upperBound"] = 0.1
        params["lowerBound"] = 0.1
        observers = []
        
    }
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        boundedAverage(currentRaw: dataPoint)
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    }
    
    func notifyObservers(data: [accelPoint]) {
        for i in observers {
            i(data)
        }
    }
    
    func boundedAverage(currentRaw: accelPoint){
        let newPoint = accelPoint()
        newPoint.count = currentRaw.count
        if currentRaw.x > (currentCenterX + params["upperBound"]!){
            currentCenterX = currentRaw.x
            newPoint.x = currentCenterX
        }else if currentRaw.x < (currentCenterX - params["lowerBound"]!){
            currentCenterX = currentRaw.x
            newPoint.x = currentCenterX
        }else{
            newPoint.x = currentCenterX
        }
        if currentRaw.y > (currentCenterY + params["upperBound"]!){
            currentCenterY = currentRaw.y
            newPoint.y = currentCenterY
        }else if currentRaw.y < (currentCenterY - params["lowerBound"]!){
            currentCenterY = currentRaw.y
            newPoint.y = currentCenterY
        }else{
            newPoint.y = currentCenterY
        }
        if currentRaw.z > (currentCenterZ + params["upperBound"]!){
            currentCenterZ = currentRaw.z
            newPoint.z = currentCenterZ
        }else if currentRaw.z < (currentCenterZ - params["lowerBound"]!){
            currentCenterZ = currentRaw.z
            newPoint.z = currentCenterZ
        }else{
            newPoint.z = currentCenterZ
        }
        notifyObservers(data: [newPoint])
    }
}
