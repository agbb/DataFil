//
//  advancedLowPassTests.swift
//  Accelerometer_Graph
//
//  Created by Alex Gubbay on 22/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import XCTest

class advancedLowPassTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCoeffGenerationButterworth(){
        
        let lowPss = AdvancedLowPass()
        
        lowPss.setParameter(parameterName: "n", parameterValue: 1)
        lowPss.setParameter(parameterName: "p", parameterValue: 1.4)
        lowPss.setParameter(parameterName: "g", parameterValue: 1)
        
        XCTAssertEqualWithAccuracy(lowPss.a0, 0.000939327, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.a1, 0.001878653, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.a2, 0.000939327, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.b1, 1.912802001, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lowPss.b2, -0.916559308, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lowPss.c,  0.990054936, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.w0, 0.031112851, accuracy: 0.0001)
    }
    
    func testCoeffGenerationCriticallyDamped(){
        
        let lowPss = AdvancedLowPass()

        lowPss.setParameter(parameterName: "n", parameterValue: 1)
        lowPss.setParameter(parameterName: "p", parameterValue: 2)
        lowPss.setParameter(parameterName: "g", parameterValue: 1)
        
        XCTAssertEqualWithAccuracy(lowPss.a0, 0.002169388, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.a1, 0.004338776, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.a2, 0.002169388, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.b1, 1.813693245, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lowPss.b2, -0.822370797, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lowPss.c,  1.553773974, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.w0, 0.048852056, accuracy: 0.0001)

    }
    
    func testCoeffGenerationBessel(){
        
        let lowPss = AdvancedLowPass()
        
        lowPss.setParameter(parameterName: "n", parameterValue: 1)
        lowPss.setParameter(parameterName: "p", parameterValue: 3)
        lowPss.setParameter(parameterName: "g", parameterValue: 3)
        
        XCTAssertEqualWithAccuracy(lowPss.a0, 0.001491842, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.a1, 0.002983684, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.a2, 0.001491827, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.b1, 1.864734364, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lowPss.b2, -0.870701733, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(lowPss.c,  0.734400887, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(lowPss.w0, 0.023075979, accuracy: 0.0001)
    }

    // For regression testing purposes.
    func testNameCorrect(){
        
        XCTAssertEqual(AdvancedLowPass().filterName.description, "Low Pass")
    }
    // Test time for filter to initalise
    func testPerformaceSetUp(){
        
        self.measure {
            let _ = AdvancedLowPass()
        }
    }
    //Included for comparison, this filter shows trivial time to complete one point calculation
    func testPerformanceSinglePoint() {
        
        let lowPss = AdvancedLowPass()
        var count = 0
        lowPss.addObserver(update: {(data: [accelPoint])->Void in
            count+=1
        })
        
        self.measure {
            
            let pointToAdd = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
            lowPss.addDataPoint(dataPoint: pointToAdd);
            
            while(count < 1){
                //Wait for all points to return
                //Timer runs until the point returns
           }
        }
    }
    
    func testPerformanceTenThouPoints(){
        
        let lowPss = AdvancedLowPass()
        var count = 0
        lowPss.addObserver(update: {(data: [accelPoint])->Void in
            count+=1
        })
        self.measure {
            for i in 0...10000{
                lowPss.addDataPoint(dataPoint: accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i))
            }
            while(count < 10000){
                //Wait for all points to return
                //Timer runs until all 1000 points return
            }
        }
    }
}
