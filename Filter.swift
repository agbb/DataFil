//
//  FilteringProtocol.swift
//  InertiaNav
//
//  Created by Alex Gubbay on 05/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation
/**
 Protocol that all filter algorithms adhere to. 
 */
protocol Filter {
    
    /**
     The full name of the filter.
     */
    var filterName: String {get}
    
    /**
     Used to store filter specifc parameters.
 */
    var params: [String:Double] {get}
    /**
     Closures that must accept a double and have void return
 */
    var observers: [(_: [accelPoint])-> Void] {get}  //
    /**
     Add another raw data point for processing
 */
    func addDataPoint(dataPoint:accelPoint) -> Void //
    /**
     Add another observer to be notified when new data is ready
 */
    func addObserver(update: @escaping (_: [accelPoint])-> Void) //
    /**
     Notify observers of new data point. Could be any number of data points.
 */
    func notifyObservers(data: [accelPoint]) //
    /**
     Update a parameter in the `params` dictonary. Allows for additional processing.
 */
    func setParameter(parameterName:String, parameterValue:Double) -> Void
}
