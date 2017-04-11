//
//  boundedAverage.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 25/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */

import Foundation

class BoundedAverage: Filter {
    
    
    var params = [String:Double]()
    var filterName = Algorithm.BoundedAverage
    var observers: [([accelPoint]) -> Void]
    var id = 0
    var currentCenterX = 0.0
    var currentCenterY = 0.0
    var currentCenterZ = 0.0
    var inital = true
    var xAvg = 0.0
    var yAvg = 0.0
    var zAvg = 0.0
    var buffer = [accelPoint]()
    var previous = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
    init(){
        params["upperBound"] = 0.1
        params["lowerBound"] = 0.1
        params["points"] = 1
        params["exponential"] = 1.0
        observers = []

    }

    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
        print("set paramter called HERE ++++++++++++ \(parameterValue)")
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {

        if Int(params["points"]!) > buffer.count{
            buffer.append(dataPoint)

        }else if Int(params["points"]!) < buffer.count{
            while Int(params["points"]!) < buffer.count {
                buffer.removeFirst()

            }
            buffer.append(dataPoint)
        }else{
            buffer.removeFirst()
            buffer.append(dataPoint)
        }
        let point = movingAverage(dataPoint: dataPoint, exponential: params["exponential"]!)
        boundedAverage(currentRaw: point)
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    
    }
    
    func notifyObservers(data: [accelPoint]) {
        for i in observers {
            i(data)
        }
    }
    
    func movingAverage(dataPoint:accelPoint, exponential: Double)->accelPoint{


            let points = (Double(params["points"]!).roundTo(places: 0))
             print("HEREEEEEEEE \(points)")
        
            if points > 1.0 {
                print("POINTSSS")
                let newPoint = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: dataPoint.count)

                if exponential > 0.0{
                    let weight = (2.0 / (points+1))
                    newPoint.xAccel = (dataPoint.xAccel * weight)+(previous.xAccel * (1.0 - weight))
                    newPoint.yAccel = (dataPoint.yAccel * weight)+(previous.yAccel * (1.0 - weight))
                    newPoint.zAccel = (dataPoint.zAccel * weight)+(previous.zAccel * (1.0 - weight))
                }else{
                    //sum points
                    for i in buffer{
                        print(i.xAccel)
                        newPoint.xAccel += i.xAccel
                        newPoint.yAccel += i.yAccel
                        newPoint.zAccel += i.zAccel
                    }
                    print(newPoint.xAccel)
                    newPoint.xAccel = newPoint.xAccel/Double(buffer.count)
                    newPoint.yAccel = newPoint.yAccel/Double(buffer.count)
                    newPoint.zAccel = newPoint.zAccel/Double(buffer.count)
                }
                previous = newPoint
                return newPoint
            }else{

                return dataPoint
            }

    }
    
    func boundedAverage(currentRaw: accelPoint){
        let newPoint = accelPoint()
        newPoint.count = currentRaw.count
        if currentRaw.xAccel > (currentCenterX + params["upperBound"]!){
            currentCenterX = currentRaw.xAccel
            newPoint.xAccel = currentCenterX
        }else if currentRaw.xAccel < (currentCenterX - params["lowerBound"]!){
            currentCenterX = currentRaw.xAccel
            newPoint.xAccel = currentCenterX
        }else{
            newPoint.xAccel = currentCenterX
        }
        if currentRaw.yAccel > (currentCenterY + params["upperBound"]!){
            currentCenterY = currentRaw.yAccel
            newPoint.yAccel = currentCenterY
        }else if currentRaw.yAccel < (currentCenterY - params["lowerBound"]!){
            currentCenterY = currentRaw.yAccel
            newPoint.yAccel = currentCenterY
        }else{
            newPoint.yAccel = currentCenterY
        }
        if currentRaw.zAccel > (currentCenterZ + params["upperBound"]!){
            currentCenterZ = currentRaw.zAccel
            newPoint.zAccel = currentCenterZ
        }else if currentRaw.zAccel < (currentCenterZ - params["lowerBound"]!){
            currentCenterZ = currentRaw.zAccel
            newPoint.zAccel = currentCenterZ
        }else{
            newPoint.zAccel = currentCenterZ
        }
        notifyObservers(data: [newPoint])
    }
}
