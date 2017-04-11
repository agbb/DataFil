//
//  FilteringProtocol.swift
//  InertiaNav
//
//  Created by Alex Gubbay on 05/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import Foundation
/**
 Protocol that all filter algorithms adhere to. 
 */
protocol Filter {
    
    /**
     The full name of the filter.
     */
    var filterName: Algorithm {get}
    
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
