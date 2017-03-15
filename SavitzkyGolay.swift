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
    var filterName = "Savitzky Golay"
    var observers: [([accelPoint]) -> Void]
    var coeffs = [Double]()
    var index =  Array(repeating: 0, count: 50)
    var id = 0
    var buffer = [accelPoint]()
    var size =  0
    init(){
        params["rightScan"] = 2
        params["leftScan"] = 2
        size = Int(params["leftScan"]!) + Int(params["rightScan"]!) + 1
       
        params["filterPolynomial"] = 2
        observers = []
        coeffs = calculateCoeffs(nl: Int(params["leftScan"]!), nr: Int(params["rightScan"]!), m: Int(params["filterPolynomial"]!))
     
    }
 
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
        coeffs = calculateCoeffs(nl: Int(params["leftScan"]!), nr: Int(params["rightScan"]!), m: Int(params["filterPolynomial"]!))
         size = Int(params["leftScan"]!) + Int(params["rightScan"]!) + 1
 
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        
        
        if self.buffer.count < self.size{
            self.buffer.append(dataPoint)
            self.notifyObservers(data:[dataPoint])
        }else{
            self.buffer.append(dataPoint)
            let current = self.buffer[(self.size-Int(self.params["rightScan"]!))]
            DispatchQueue.global().async {
                let newPoint = self.applyFilter(pointToProcess: current, buffer: self.buffer)
                
                DispatchQueue.main.sync {
                    self.notifyObservers(data: [newPoint])
                }
            }
            self.buffer.removeFirst()
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
    
    
    
    /*
     Applies the filter to the given point and buffer.
     
     
     */
    func applyFilter(pointToProcess: accelPoint, buffer: [accelPoint]) -> accelPoint{
        
        let nr = Int(params["rightScan"]!)
        let nl = Int(params["leftScan"]!)
        
        var newPoint = accelPoint()
        newPoint.count = pointToProcess.count+nr
    
        
        let size = nl + nr + 1

        var tempX = 0.0
        var tempY = 0.0
        var tempZ = 0.0
        
        
        for i in 0...size-1{
            let coeff = coeffs[i]
            tempX = tempX + (buffer[i].xAccel * coeff)
            tempY = tempY + (buffer[i].yAccel * coeff)
            tempZ = tempZ + (buffer[i].zAccel * coeff)
        }
        
    
        newPoint.xAccel = tempX
        newPoint.yAccel = tempY
        newPoint.zAccel = tempZ
        
        return newPoint
        
    }
    
    
    
    
    
    func calculateCoeffs(nl: Int, nr: Int, m: Int) -> [Double]{

        let ld = 0
        let np = nl + nr + 1
        var c = Array(repeating: 0.0, count: np + 2)
        let matrix = fortranMatrixOps()
        
        let max = 6
        
        var kk = 0,
        mm = 0
        
        var index = Array(repeating: 0, count:max+2)
        
        
        var d = 0.0,
        fac = 0.0,
        sum = 0.0
        
        var a = Array(repeating: Array(repeating: 0.0, count: max+2), count: max+2)
        var b = Array(repeating: 0.0, count: max+2)
        
        
        
        if (np < (nl+nr+1)) || (nl < 0) || (nr < 0) || (ld > m) || (m > max) || (nl + nr < m){
            print("Invalid arguments passed into coeff calc.")
            //TODO: seperate for more meaningful errors.
        }
        
        for ipj in 0...(m * 2) { //14
            sum = 0.0
            if ipj == 0{
                sum = 1.0
            }
            
            for k in 1...nr{ //11
                
                sum = sum + (Double(k)^^Double(ipj))
                
            }
            
            for k in 1...nl{ //12
                sum = sum + (Double((-k))^^Double(ipj))
                
            }
            
            
            mm = min(ipj, 2 * m - ipj)
            
            for imj in stride(from:-mm, to: mm+1, by: 2){ //13
                
                a[1+(ipj+imj)/2][1+(ipj-imj)/2] = sum
                
            }
        }
     
        
        let decompOutput = matrix.luDecomposition(a: a, n: m+1, index: index, d: d)
        index = decompOutput.index
        a = decompOutput.a
        
        for j in 1...(m+1){ //15
            b[j] = 0
        }
        b[ld+1] = 1
        
        b = matrix.luBacksubstitute(a:a, n:m+1, np:max+1, index:index, b: b)
        
        
        for kk in 1...np{ //16
            c[kk] = 0.0
        }
        
        for k in -nl...nr{ //18
            sum = b[1]
            fac = 1
            for mm in 1...m{ //17
                fac = fac*Double(k)
                sum = sum + b[mm+1] * fac
                
            }
            kk = ((np-k) % np) + 1
            c[kk] = sum
        }
        
        c.removeFirst()
        c.removeLast()
        
        let output = shift(index:nr+1, input: c)
        return output
    }
    
    func shift(index: Int, input: [Double]) -> [Double]{
       
        var output = input[index..<input.count]
        output += input[0..<index]
        return Array(output)
    }
    
    
}
