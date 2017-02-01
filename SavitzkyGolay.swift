//
//  Savitzky-Golay.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 01/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

class SavitzkyGolay: FilteringProtocol {
    
    
    var params = [String:Double]()
    var filterName = "High Pass"
    var observers: [([accelPoint]) -> Void]
    
    var id = 0
    
    init(){
        
        observers = []
    }
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        highPass(currentRaw: dataPoint)
    }
    
    func addObserver(update: @escaping ([accelPoint]) -> Void) {
        observers.append(update)
    }
    func notifyObservers(data: [accelPoint]) {
        for i in observers {
            i(data)
        }
    }
    
    func highPass(currentRaw: accelPoint){
        let newPoint = accelPoint()
       
        notifyObservers(data: [newPoint])
    }
    
    func calculateCoeffs(outputSize: Int, leftScan: Int, rightScan: Int, order: Int, smoothingPolynomialOrder: Int) -> [Double]{
        
        var outputArray = Array(repeating: 0.0, count: outputSize)
        var matrix = fortranMatrixOps()
        
        let max = 6
        
        var imj = 0,
            ipj = 0,
            j = 0,
            k = 0,
            kk = 0,
            mm = 0
        
        var index = Array(repeating: 0, count: max+1)
        
        var d = 0.0,
            fac = 0.0,
            sum = 0.0
        
        var a = Array(repeating: Array(repeating: 0.0, count: max+1), count: max+1)
        var b = Array(repeating: 0.0, count: max+1)
        
        
        
        if (outputSize < (leftScan+rightScan+1)) || (leftScan < 0) || (rightScan < 0) || (order > smoothingPolynomialOrder) || (smoothingPolynomialOrder > max){
            print("Invalid arguments passed into coeff calc.")
            //TODO: seperate for more meaningful errors.
        }
        
        let loopOrder = order * 2
        for ipj in 0...(loopOrder) { //14
            sum = 0
            if ipj == 0{
                sum = 1
            }
            
            for k in 1...rightScan{ //11
                sum += (Double(k)^^Double(ipj))
            }
            
            for k in 1...leftScan{ //12
                sum += (Double(-k)^^Double(ipj))
            }
            
            let maxMipj = 2 * max - ipj
            
            if(ipj<maxMipj){
                mm = ipj
                }else{
                mm = maxMipj
            }
            
            for imj in stride(from:-mm, to: mm, by: 2){ //13
                
                let i = 1+(ipj+imj)/2
                let j = 1+(ipj-imj)/2
                
                a[i][j] = sum
                
            }
        }
        
        //a = luDecomposition(a, smoothingPolynomialOrder+1, index, d)
        
        for j in 1...(smoothingPolynomialOrder+1){ //15
            b[j] = 0
        }
        b[order+1] = 1
        
        let backSubResult = matrix.luBacksubstitute(a:a, n:order, np:max+1, index:index, b: b)
        
        a = backSubResult.a
        index = backSubResult.index
        b = backSubResult.b
        
        
        for kk in 1...outputSize{ //16
            outputArray[kk] = 0.0
        }
        
        for k in -leftScan...rightScan{ //18
            sum = b[1]
            fac = 1
            for mm in 1...smoothingPolynomialOrder{ //17
                fac = fac*Double(k)
                sum = sum + b[mm+1] * fac
            }
            kk = ((outputSize-k) % outputSize) + 1
            outputArray[kk] = sum
        }
        return outputArray
    }
  
}
