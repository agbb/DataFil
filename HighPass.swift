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
    
    var id = 0
    
    init(){

        params["alpha"] = 0.5
        
        self.previousValue = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        observers = []
    }
    
    func getFilterName() -> String{
        return filterName
    }

    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
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
        let newPoint = accelPoint()
        newPoint.x = (params["alpha"]! * currentRaw.x) + (previousValue.x * (1.0 - params["alpha"]!))
        newPoint.y = params["alpha"]! * currentRaw.y + previousValue.y * (1.0 - params["alpha"]!)
        newPoint.z = params["alpha"]! * currentRaw.z + previousValue.z * (1.0 - params["alpha"]!)
        newPoint.count = currentRaw.count
        previousValue = newPoint
        notifyObservers(data: [newPoint])
    }
}
