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
    
    var observers: [(_: [Double])-> Void] {get}  //Closures that must accept a double and have void return
    
    func addDataPoint(dataPoint:Double) -> Void //Add another raw data point for processing
    
    func addObserver(update: @escaping (_: [Double])-> Void) //Add another observer to be notified when new data is ready
    
    func notifyObservers(data: [Double]) //Notify observers of new data point. Could be any number of data points.
    
}
