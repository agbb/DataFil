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
    
    func calculateCoeffs(np: Int, nl: Int, nr: Int, ld: Int, m: Int) -> [Double]{
        
        var c = Array(repeating: 0.0, count: np + 2)
        let matrix = fortranMatrixOps()
        
        let max = 6
        
        var imj = 0,
            ipj = 0,
            j = 0,
            k = 0,
            kk = 0,
            mm = 0
        
        var index = Array(repeating: 0, count:max+1)
        
      //  index[1] = 0
       // j = 3
        
        /* for i in 2...nl+1{
            index[i] = i - j
            j = j + 2
        }
        j = 2
        for i in nl+1...nl+nr+1{
            index[i] = i - j
            j = j + 2
        } */
        var d = 0.0,
            fac = 0.0,
            sum = 0.0
        
        var a = Array(repeating: Array(repeating: 0.0, count: max+1), count: max+1)
        var b = Array(repeating: 0.0, count: max+1)
        
        
        
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
        
        index = matrix.luDecomposition(a: a, n: m+1, index: index, d: d)
        
        
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
