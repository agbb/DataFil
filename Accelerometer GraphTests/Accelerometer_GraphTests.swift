//
//  Accelerometer_GraphTests.swift
//  Accelerometer GraphTests
//
//  Created by Alex Gubbay on 04/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import XCTest
@testable import Accelerometer_Graph

class Accelerometer_GraphTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCoeffs222(){
        let expectedCoeffs222 = [0.0, 0.48571428571428565, 0.3428571428571428, -0.085714285714285743, -0.085714285714285743, 0.3428571428571428, 0.0]
        let expectedCoeffs552 = [0.0, 0.20745920745920746, 0.19580419580419581, 0.16083916083916083, 0.10256410256410256, 0.020979020979020963, -0.083916083916083933, -0.083916083916083933, 0.020979020979020963, 0.10256410256410256, 0.16083916083916083, 0.19580419580419581, 0.0]
        let savgol = SavitzkyGolay()
        let coeffs = savgol.calculateCoeffs(nl: 2, nr: 2, m: 2)
        XCTAssertEqual(coeffs.count, 7)
        XCTAssertEqual(expectedCoeffs222, coeffs)
    }
    
    func testCoeffs552(){
      let expectedCoeffs552 = [0.0, 0.20745920745920746, 0.19580419580419581, 0.16083916083916083, 0.10256410256410256, 0.020979020979020963, -0.083916083916083933, -0.083916083916083933, 0.020979020979020963, 0.10256410256410256, 0.16083916083916083, 0.19580419580419581, 0.0]
    let savgol = SavitzkyGolay()
    let coeffs = savgol.calculateCoeffs(nl: 5, nr: 5, m: 2)
    XCTAssertEqual(coeffs.count, 13)
    XCTAssertEqual(expectedCoeffs552, coeffs)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
