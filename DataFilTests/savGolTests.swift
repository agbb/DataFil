//
//  Accelerometer_GraphTests.swift
//  Accelerometer GraphTests
//
//  Created by Alex Gubbay on 04/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import XCTest

class savGolTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: Test coefficients generation against canonical examples.
    func testCoeffs222(){
        let expectedCoeffs222 = [-0.085714285714285743, 0.3428571428571428, 0.48571428571428565, 0.3428571428571428, -0.085714285714285743]
        let savgol = SavitzkyGolay()
        let coeffs = savgol.calculateCoeffs(nl: 2, nr: 2, m: 2)
        var sum = 0.0
        for element in coeffs{
            sum += element
        }
        XCTAssertEqualWithAccuracy(sum, 1.0, accuracy: 0.000001)
        XCTAssertEqual(coeffs.count, 5)
        XCTAssertEqual(expectedCoeffs222, coeffs)
    }
    
    func testCoeffs552(){
        let expectedCoeffs552 = [-0.083916083916083933, 0.020979020979020963, 0.10256410256410256, 0.16083916083916083, 0.19580419580419581, 0.20745920745920746, 0.19580419580419581, 0.16083916083916083, 0.10256410256410256, 0.020979020979020963, -0.083916083916083933]
        let savgol = SavitzkyGolay()
        let coeffs = savgol.calculateCoeffs(nl: 5, nr: 5, m: 2)
        
        var sum = 0.0
        for element in coeffs{
            sum += element
        }
        XCTAssertEqualWithAccuracy(sum, 1.0, accuracy: 0.000001) // correctly calculated coeffs should add up to 1, with precisison error.
        XCTAssertEqual(coeffs.count, 11)
        XCTAssertEqual(expectedCoeffs552, coeffs)
    }
    
    func testCoeffApplicationBaseCase(){
        let savgol = SavitzkyGolay()//implictly sets up with nl=nr=2, m=2
        var buffer = [accelPoint]()
        
        for i in 0...5{
            buffer.append(accelPoint(dataX: 1.0, dataY: 1.0, dataZ: 1.0, count: i))
        }
        let output1 = savgol.applyFilter(pointToProcess: accelPoint(dataX: 1.0, dataY: 1.0, dataZ: 1.0, count: 6), buffer: buffer)
        XCTAssertEqual(output1.count, 8) //count should equal the input + the forward scan lag (2 here)
        
        XCTAssertEqualWithAccuracy(Double(output1.xAccel), Double(1.0), accuracy: 0.00001) //All 1s as input should yield an out put of 1.0
        XCTAssertEqualWithAccuracy(output1.yAccel, Double(1.0), accuracy: 0.000001)
        XCTAssertEqualWithAccuracy(output1.zAccel, Double(1.0), accuracy: 0.000001)//check for all axes
    }
    
    func testLuDecomp(){
        let aIn = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 5.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 10.0, 0.0, 34.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
        
        let indexIn = [0, 0, 0, 0, 0, 0, 0, 0]
        
        let dIn = 0.0
        let n = 3
        
        let indexOut = [0, 1, 2, 3, 0, 0, 0, 0]
        let aOut = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 5.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 2.0, 0.0, 14.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]]
        
        let matrixFunc = FortranMatrixOps()
        
        let output = matrixFunc.luDecomposition(a: aIn, n: n, index: indexIn, d: dIn)
        
        XCTAssertEqual(output.a.count, aOut.count)
        for i in 0...output.a.count-1{
            XCTAssertEqual(output.a[i], aOut[i])
        }
        
        XCTAssertEqual(output.index, indexOut)
    }
    
    func testCoeffApplicationExample(){
        
        let savgol = SavitzkyGolay() //implictly sets up with nl=nr=2, m=2
        var buffer = [accelPoint]()
        
        for i in 0...5{
            buffer.append(accelPoint(dataX: Double(i % 2), dataY: Double(i % 2), dataZ: Double(i % 2), count: i))
        }
        
        let output2 = savgol.applyFilter(pointToProcess: accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 6), buffer: buffer)
        XCTAssertEqual(output2.count, 8) //count should equal the input + the forward scan lag (2 here)
        XCTAssertEqualWithAccuracy(output2.xAccel, 0.685, accuracy: 0.001)//confirm manual calulation for output.
        XCTAssertEqualWithAccuracy(output2.yAccel, 0.685, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(output2.zAccel, 0.685, accuracy: 0.001)//check for all axes
    }
    
    func testNameCorrect(){
        
        XCTAssertEqual(SavitzkyGolay().filterName.description, "Savitzky Golay Filter")
    }
}
