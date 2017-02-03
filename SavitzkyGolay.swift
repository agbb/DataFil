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
    var leftBuffer = [accelPoint]()
    var rightBuffer = [accelPoint]()
    var buffer = [accelPoint]()
    var size =  0
    init(){
        params["rightScan"] = 2
        params["leftScan"] = 2
        size = Int(params["leftScan"]!) + Int(params["rightScan"]!) + 1
       
        params["filterPolynomial"] = 2
        observers = []
        coeffs = calculateCoeffs(nl: Int(params["leftScan"]!), nr: Int(params["rightScan"]!), m: Int(params["filterPolynomial"]!))
        setUpWraparoundArray()
     
    }
    
    func setUpWraparoundArray(){
        
        let nl = Int(params["leftScan"]!)
        let nr = Int(params["rightScan"]!)
        
        var j = 3
        
        index[0] = 0
        index[1] = 0
        
        for i in 2...nl+1{
            index[i] = i - j
            j = j + 2
        }
        j = 2
        for i in nl+1...nl+nr+1{
            index[i] = i - j
            j = j + 2
        }
    }
    
    func getFilterName() -> String{
        return filterName
    }
    
    func setParameter(parameterName: String, parameterValue: Double) {
        params[parameterName] = parameterValue
    }
    
    func addDataPoint(dataPoint: accelPoint) -> Void {
        
        
        
        
        buffer.append(dataPoint)
        
        if buffer.count < Int(params["leftScan"]!){
            
            for i in 0...Int(params["leftScan"]!)-1{ // initally fill history with 0s.
                buffer.append(accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: dataPoint.count))
            }
        }
        
        if buffer.count < size+1{
            print("returning blank point")
            let blankPoint = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: dataPoint.count)
            notifyObservers(data: [blankPoint])
        }else{
             let current = buffer[(size-Int(params["rightScan"]!))]
             let newPoint = applyFilter(pointToProcess: current, buffer: buffer)
             notifyObservers(data: [newPoint])
            buffer.removeFirst()
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
    
    
    
    
    func applyFilter(pointToProcess: accelPoint, buffer: [accelPoint]) -> accelPoint{
        let newPoint = accelPoint()
        newPoint.count = pointToProcess.count
        let nr = Int(params["rightScan"]!)
        let nl = Int(params["leftScan"]!)
        
        let size = nl + nr + 1

        var tempX = 0.0
        for i in 1...nl{
            let coeff = coeffs[i]
            tempX = tempX + (buffer[i].x * coeff)
        }
        let currentMidPointCoeff = coeffs[size-nr]
        tempX = tempX + (pointToProcess.x * currentMidPointCoeff)
        
        for i in nl+1...size{
             let coeff = coeffs[i]
            tempX = tempX + (buffer[i].x * coeff)
        }
        newPoint.x = tempX
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
        
        return c
    }
    
}
