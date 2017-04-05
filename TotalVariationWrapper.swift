//
//  TotalVariationWrapper.swift
//  DataFil
//
//  Created by Alex Gubbay on 03/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */

import Foundation

class TotalVariationWrapper: Filter {
    
    
    
    var params = [String:Double]()
    var filterName = Algorithm.TotalVariation
    var observers: [([accelPoint]) -> Void]
    var id = 0
    
    var buffer = [accelPoint]()
    
    init(){
        params["lambda"] = 0.05
        params["bufferSize"] = 500
        observers = []
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
