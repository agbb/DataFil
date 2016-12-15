//
//  FilteringProtocol.swift
//  InertiaNav
//
//  Created by Alex Gubbay on 05/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation

protocol FilteringProtocol {
    
    
    var filterName: String {get}  //The full name of the filter
    var params: [String:Double] {get}
    var observers: [(_: [accelPoint])-> Void] {get}  //Closures that must accept a double and have void return
    
    func addDataPoint(dataPoint:accelPoint) -> Void //Add another raw data point for processing
    
    func addObserver(update: @escaping (_: [accelPoint])-> Void) //Add another observer to be notified when new data is ready
    
    func notifyObservers(data: [accelPoint]) //Notify observers of new data point. Could be any number of data points.
    
    func setParameter(parameterName:String, parameterValue:Double) -> Void
}
