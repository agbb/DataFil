//
//  savGolPerformance.swift
//  Accelerometer_Graph
//
//  Created by Alex Gubbay on 22/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import XCTest

class savGolPerformance: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test time for filter to initalise, with default parameters
    func testPerformaceSetUp0(){
        self.measure {
            _ = SavitzkyGolay()
        }
    }
    
    func testPerformaceSetUp1(){
        let savGol = SavitzkyGolay()
        self.measure {
            _ = savGol.calculateCoeffs(nl: 16, nr: 16, m: 6)
        }
    }
    
    func testPerformaceSetUp2(){
        let savGol = SavitzkyGolay()
        self.measure {
            _ = savGol.calculateCoeffs(nl: 32, nr: 32, m: 6)
        }
    }
    
    func testPerformaceSetUp3(){
        let savGol = SavitzkyGolay()
        self.measure {
            _ = savGol.calculateCoeffs(nl: 64, nr: 64, m: 6)
        }
    }
    
    func testPerformaceSetUp4(){
        let savGol = SavitzkyGolay()
        self.measure {
            _ = savGol.calculateCoeffs(nl: 128, nr: 128, m: 6)
        }
    }
    
    func testPerformaceSetUp5(){
        let savGol = SavitzkyGolay()
        self.measure {
            _ = savGol.calculateCoeffs(nl: 256, nr: 256, m: 6)
        }
    }
    
    func testPerformaceSetUp6(){
        let savGol = SavitzkyGolay()
        self.measure {
            _ = savGol.calculateCoeffs(nl: 512, nr: 512, m: 6)
        }
    }
    
    func testPerformaceSetUp7(){
        let savGol = SavitzkyGolay()
        self.measure {
            _ = savGol.calculateCoeffs(nl: 1024, nr: 1024, m: 6)
        }
    }
    
    func testPerformaceSetUp8(){
        let savGol = SavitzkyGolay()
        self.measure {
            _ = savGol.calculateCoeffs(nl: 2048, nr: 2048, m: 6)
        }
    }
    
    
    //Included for comparison, this filter shows trivial time to complete one point calculation
    func testPerformanceSinglePoint() {
        
        self.measure {
            
            let allPointsAccountedExpectation = self.expectation(description: "allPointedAccountedFor")
            
            let savGol = SavitzkyGolay()
            var count = 0
            savGol.addObserver(update: {(data: [accelPoint])->Void in
                
                count+=1
                if count > 1{
                    
                    allPointsAccountedExpectation.fulfill()
                }
            })
            
            for i in 0...1{
                savGol.addDataPoint(dataPoint: accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i));
            }
            
            self.waitForExpectations(timeout: 10, handler: { error in
                
            })
        }
    }
    
    func testPerformanceTenThouPoints0(){
        
        self.measure {
            
            let allPointsAccountedExpectation = self.expectation(description: "allPointedAccountedFor")
            
            let savGol = SavitzkyGolay()
            var count = 0
            savGol.addObserver(update: {(data: [accelPoint])->Void in
                
                count+=1
                if count > 10000{

                    allPointsAccountedExpectation.fulfill()
                }
            })
            
            for i in 0...10000{
                savGol.addDataPoint(dataPoint: accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i));
            }
 
            self.waitForExpectations(timeout: 10, handler: { error in
            
            })
        }
    }

    
}
