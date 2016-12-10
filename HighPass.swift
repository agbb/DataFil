//
//  HighPass.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 08/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation

class HighPass: FilteringProtocol{
    
    var alpha = 0.0
    var filterName = "High Pass"
    var observers: [([Double]) -> Void]
    var previousValue = 0.0
    var id = 0
    
    init(alpha: Double){
        self.alpha = alpha
        observers = []
    }
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setAlpha(alpha: Double){
        self.alpha = alpha
    }
    
    func addDataPoint(dataPoint: Double) -> Void {
        print("got data")
        highPass(currentRaw: dataPoint)
    }
    
    func addObserver(update: @escaping ([Double]) -> Void) {
        observers.append(update)
    }
    func notifyObservers(data: [Double]) {
        for i in observers {
            i(data)
        }
    }
    
    func highPass(currentRaw: Double){
        var output = alpha * currentRaw + previousValue * (1.0 - alpha)
        previousValue = output
        notifyObservers(data: [output])
    }
}
