//
//  TotalVariationWrapper.swift
//  DataFil
//
//  Created by Alex Gubbay on 03/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

class TotalVariationWrapper: FilteringProtocol {
    
    
    
    var params = [String:Double]()
    var filterName = "Total Variaion Denoising"
    var observers: [([accelPoint]) -> Void]
    var id = 0
    
    var buffer = [accelPoint]()
    
    init(){
        params["lambda"] = 0.05
        params["bufferSize"] = 500
        observers = []
    }
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setParameter(parameterName: String, parameterValue: Double) {
        
        params[parameterName] = parameterValue
        
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        buffer.append(dataPoint)
        
        if buffer.count >= Int(params["bufferSize"]!){
            let output = TVDenoising(setup: params).denoise(input: buffer, axis: "x")
            notifyObservers(data: output)
            buffer.removeAll()
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

}
