//
//  advancedLowPass.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 20/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
// A programitic implementation and adaptation of the mathematics found at http://unicorn.us.com/trading/allpolefilters.html
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */


import Foundation

class advancedLowPass: Filter {
    
    var params = [String:Double]()
    var filterName = Algorithm.LowPass
    var observers: [([accelPoint]) -> Void]
    var rawMinusOne: accelPoint
    var rawMinusTwo: accelPoint
    var processedMinusOne: accelPoint
    var processedMinusTwo: accelPoint
    var id = 0
    var c = 0.0, fStar = 0.0, w0 = 0.0, k1 = 0.0, k2 = 0.0, a0 = 0.0, a1 = 0.0, a2 = 0.0, b1 = 0.0, b2 = 0.0
    
    init(){
        
        self.rawMinusOne = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        self.rawMinusTwo = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        self.processedMinusOne = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        self.processedMinusTwo = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
        observers = []
        params["p"] = sqrt(2.0)
        params["g"] = 1.0
        params["n"] = 1.0
        params["fs"] = 10
        params["f0"] = 0.1
        calculateCoeffcients()
    }

    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
        c = 0.0
        fStar = 0.0
        w0 = 0.0
        k1 = 0.0
        k2 = 0.0
        a0 = 0.0
        a1 = 0.0
        a2 = 0.0
        b1 = 0.0
        b2 = 0.0
        calculateCoeffcients()
    }
    
    func calculateCoeffcients(){
        
   
        let p = params["p"]!
        let g = params["g"]!

        c  = 1/sqrt((2.0*g - p*p + sqrt((2.0*g-p*p)^^2.0 - 4.0*g*g*(1.0 - 2.0^^(1.0/1.0))))/2.0)
        fStar = c * params["f0"]! / params["fs"]!
        
        if(fStar < 0 || fStar > 0.125 ){
            print("WARNING: Invalid value for fStar coefficient")
        }
        
        w0 = tan(Double.pi*fStar)
        k1 = p * w0
        k2 = g * w0^^2.0
        a0 = k2/(1.0 + k1 + k2)
        a1 = 2.0 * a0
        a2 = a0
        b1 = 2.0 * a0 * (1.0 / k2 - 1.0)
        b2 = 1.0 - (a0 + a1 + a2 + b1)

    }

    
    func addDataPoint(dataPoint: accelPoint) -> Void {

        lowPass(currentRaw: dataPoint)
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    }
    func notifyObservers(data: [accelPoint]) {
        for i in observers {
            i(data)
        }
    }
    
    func lowPass(currentRaw: accelPoint){
        
        var xCurrent = currentRaw.xAccel
        var yCurrent = currentRaw.yAccel
        var zCurrent = currentRaw.zAccel
        
        for _ in 0...Int(params["n"]!)-1{

         xCurrent = a0 * xCurrent + a1 * rawMinusOne.xAccel + a2 * rawMinusTwo.xAccel + b1 * processedMinusOne.xAccel + b2 * processedMinusTwo.xAccel

        
         yCurrent = a0 * yCurrent + a1 * rawMinusOne.yAccel + a2 * rawMinusTwo.yAccel + b1 * processedMinusOne.yAccel + b2 * processedMinusTwo.yAccel
        
         zCurrent = a0 * zCurrent + a1 * rawMinusOne.zAccel + a2 * rawMinusTwo.zAccel + b1 * processedMinusOne.zAccel + b2 * processedMinusTwo.zAccel
        }
        rawMinusTwo = accelPoint(dataX:rawMinusOne.xAccel, dataY:rawMinusOne.yAccel, dataZ:rawMinusOne.zAccel, count : currentRaw.count)
        rawMinusOne = accelPoint(dataX:currentRaw.xAccel, dataY:currentRaw.yAccel, dataZ:currentRaw.zAccel, count : currentRaw.count)
        
        let newPoint = accelPoint(dataX:xCurrent, dataY:yCurrent, dataZ:zCurrent, count : currentRaw.count)
        
        processedMinusTwo = accelPoint(
            dataX:processedMinusOne.xAccel,dataY:processedMinusOne.yAccel, dataZ: processedMinusOne.zAccel, count:currentRaw.count)
        processedMinusOne = accelPoint(
            dataX:xCurrent, dataY:yCurrent, dataZ:zCurrent, count : currentRaw.count)

        notifyObservers(data: [newPoint])
    }
    
}
