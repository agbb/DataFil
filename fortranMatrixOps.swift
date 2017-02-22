//
//  fortranMatrixOps.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 01/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

class fortranMatrixOps {
    
    func luBacksubstitute(a: [[Double]], n: Int, np: Int, index: [Int], b:[Double]) -> [Double]{
        
        var wB = b
        var wA = a
        var wIndex = index
        var sum = 0.0
        var ii = 0
        
        for i in 1...n{
            let ll = wIndex[i]
            sum = wB[ll]
            wB[ll] = wB[i]

            if ii != 0{

                for j in ii...i-1{
                   sum = sum - wA[i][j] * wB[j]

                }
            }else if sum != 0{
                ii = i
            }
            wB[i] = sum
        }
        for i in stride(from:n, to:0, by:-1){

            sum = wB[i]
            
            if (i < n ){
                for j in i+1...n{
                    sum = sum - wA[i][j] * wB[j]
                }
            }
            wB[i] = sum/wA[i][i]
        }
        
        return wB
    }
    
    
    func luDecomposition(a: [[Double]], n: Int, index: [Int], d:Double) -> (index:[Int], a:[[Double]]){
        
        let nmax = 100, tiny = 1.0e-20
        
        var wA = a
        var wIndex = index
        var wD = d
        
        var sum = 0.0
        var dum = 0.0
        var vv = Array(repeating: 0.0, count: nmax)
        var aamax = 0.0
        var imax = 0
        
        wD = 1
        
        for i in 1...n{
            
            aamax = 0.0
            
            for j in 1...n{
                
                let absA = abs(wA[i][j])
                if  absA > aamax {
                    aamax = absA
                }
            }
            if aamax == 0{
                print("singular matrix")
            }
            vv[i] = 1.0/aamax
        }
        for j in 1...n{
            if j > 1 {
                for i in 1...j-1{
                    sum = wA[i][j]
                    if i > 1 {
                        for k in 1...i-1{
                            sum = sum - wA[i][k] * wA[k][j]
                        }
                        wA[i][j] = sum
                    }
                }
            }
            aamax = 0.0
            
            for i in j...n{
                sum = wA[i][j]
                if j > 1 {
                    for k in 1...j-1{
                        sum = sum - wA[i][k] * wA[k][j]
                    }
                    wA[i][j] = sum
                }
                dum = vv[i] * abs(sum)
                if dum >= aamax {
                    imax = i
                    aamax = dum
        
                }
            }
            if j != imax {
                for k in 1...n{
                    dum = wA[imax][k]
                    wA[imax][k] = wA[j][k]
                    wA[j][k] = dum
                }
                wD = -wD
                vv[imax] = vv[j]
            }
            wIndex[j] = imax
            if j != n{
                if wA[j][j] == 0.0 {
                    wA[j][j] = tiny
                }
                dum = 1/wA[j][j]
                
                for i in j+1...n{
                    wA[i][j] = wA[i][j] * dum
                }
            }
        }
        if wA[n][n] == 0{
            wA[n][n] = tiny
        }

        return (wIndex,wA)
    }
  
}
