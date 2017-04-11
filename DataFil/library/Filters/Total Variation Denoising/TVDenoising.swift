//
//  TVDenoising.swift
//  InertiaNav
//
//  Created by Alex Gubbay on 21/11/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import Foundation


class TVDenoising{
    
    var proceccedPoint = 0
    var currentPoint = 0
    var k = 1
    var kZero = 1
    var kMinus = 1
    var kPlus = 1
    var N = 0
    var vMin = 0.0
    var vMax = 0.0
    var uMin = 0.0
    var uMax = 0.0
    var lambda = 0.5
    var params = [String:Double]()
    var input = [accelPoint]()
    var output = [accelPoint]()
    var startingCount = 0
    
    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
        lambda = params["lambda"]!
    }

    init(setup: [String:Double]){
        params = setup
    }
    
    func calibrateInputData(data: [accelPoint])-> [accelPoint]{
        startingCount = data[0].count
        var outputArray = [accelPoint]()
        outputArray.append(accelPoint(dataX: -1.0, dataY: -1.0, dataZ: -1.0, count: -1))
        for d in 0..<data.count{
            outputArray.append(accelPoint(dataX: data[d].xAccel, dataY: data[d].yAccel, dataZ: data[d].zAccel, count: d))
        }
        outputArray.append(accelPoint(dataX: -1.0, dataY: -1.0, dataZ: -1.0, count: -1))
        return outputArray
    }
    
    func setOuputPoint(position: Int, data: Double){
        
        if(position > proceccedPoint){
            proceccedPoint = position
        }
        
        output[position].xAccel = data
    }

    func calibrateOutputData(data: [accelPoint]) -> [accelPoint]{
        var output = data
        output.removeLast()
        output.removeFirst()
        for d in startingCount..<(startingCount+output.count){ //first index to the last
            let index = d - startingCount
            output[index].count = d
        }
        return output
    }
    
    func denoise(input: [accelPoint], axis: String) -> [accelPoint] {
        
        N = input.count-1
        self.input = calibrateInputData(data: input)
        self.output = calibrateInputData(data: input)
  
        
        if(input.count < 1){
            return output
        }
        
        vMin = input[1].getAccelAxis(axis: axis) - lambda
        vMax = input[1].getAccelAxis(axis: axis) + lambda
        uMin = lambda
        uMax = -lambda
        var returnToTop = false

        innerLoop: while true{
            
            returnToTop = false
            
            //LINE 2
            
            if(k == N){

                output[N].setAccelAxis(axis: axis, data:(vMin + uMin))
                return calibrateOutputData(data: output)
            }
            
            //LINE 3
            
            if(input[k+1].getAccelAxis(axis: axis) + uMin < vMin - lambda){
                
                for i in kZero ... kMinus{

                    output[i].setAccelAxis(axis: axis, data: vMin)
                }
                
                k = kMinus + 1
                kZero = kMinus + 1
                kPlus = kMinus + 1
                kMinus = kMinus + 1
                
                
                vMin = input[k].getAccelAxis(axis: axis)
                vMax = input[k].getAccelAxis(axis: axis) + (2 * lambda)
                
                uMin = lambda
                uMax = -lambda
                
                //LINE 4
                
            }else if input[k+1].getAccelAxis(axis: axis) + uMax > vMax + lambda {
                
                for i in kZero ... kPlus{

                    output[i].setAccelAxis(axis: axis, data: vMax)
                }
                
                k = kPlus + 1
                kZero = kPlus + 1
                kMinus = kPlus + 1
                kPlus = kPlus + 1
                
                vMin = input[k].getAccelAxis(axis: axis) - 2 * lambda
                vMax = input[k].getAccelAxis(axis: axis)
                uMin = lambda
                uMax = -lambda
                
                //LINE 5
                
            }else{
                
                k = k + 1
                uMin = uMin + input[k].getAccelAxis(axis: axis) - vMin
                uMax = uMax + input[k].getAccelAxis(axis: axis) - vMax
                
                //LINE 6 PART ONE & PART 2
                
                if uMin >= lambda {
                    
                    vMin = vMin + (uMin - lambda)/Double(k - kZero + 1)
                    uMin = lambda
                    kMinus = k
                    
                }
                
                if uMax <= -lambda {
                    
                    vMax = vMax + (uMax + lambda)/Double(k - kZero + 1)
                    uMax = -lambda
                    kPlus = k
                    
                }
            }
        
            //LINE 7
            if k < N {
                returnToTop = true
            }
            //LINE 8
            if !returnToTop{
                if uMin < 0 {
                    
                    for i in kZero ... kMinus{
                        output[i].setAccelAxis(axis: axis, data: vMin)
                    }
                    
                    k = kMinus + 1
                    kZero = kMinus + 1
                    kMinus = kMinus + 1
                    
                    vMin = input[k].getAccelAxis(axis: axis)
                    uMin = lambda
                    uMax = input[k].getAccelAxis(axis: axis) + lambda - vMax
                    
                    //LINE 9
                    
                }else if uMax > 0 {
                    
                    for i in kZero ... kPlus{
                        output[i].setAccelAxis(axis: axis, data: vMax)
                        
                    }
                    
                    k = kPlus + 1
                    kZero = kPlus + 1
                    kPlus = kPlus + 1
                    
                    vMax = input[k].getAccelAxis(axis: axis)
                    uMax = -lambda
                    uMin = input[k].getAccelAxis(axis: axis) - lambda - vMin
                    
                }else{
                    
                    //LINE 10
                    
                    for i in kZero ... output.count - 1{
                        output[i].setAccelAxis(axis: axis, data: (vMin + uMin)/Double(k - kZero + 1))
                    }
                    
                    return calibrateOutputData(data: output)
                }
            }
        }
        return calibrateOutputData(data: output)
    }
}
