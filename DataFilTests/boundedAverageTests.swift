//
//  boundedAverageTests.swift
//  Accelerometer_Graph
//
//  Created by Alex Gubbay on 22/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import XCTest

class boundedAverageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMinimumJumpAttenuation(){
        
        let boundAvg = BoundedAverage()
        var outputData = [accelPoint]()
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        for i in 0...100{
            let input = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i)
            if i % 2 == 0{
                input.xAccel = 0.09
                input.yAccel = 0.09
                input.zAccel = 0.09
            }
            boundAvg.addDataPoint(dataPoint: input)
        }
        
        for point in outputData{
            XCTAssertEqual(point.xAccel, 0.0)
            XCTAssertEqual(point.yAccel, 0.0)
            XCTAssertEqual(point.zAccel, 0.0)
        }
    }
    
    func testAverage(){
        
        let boundAvg = BoundedAverage()
        boundAvg.setParameter(parameterName: "points", parameterValue: 100)
        var outputData = [accelPoint]()
        
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        
        for i in 0...100{
            
            let input = accelPoint(dataX: Double(i), dataY: Double(i), dataZ: Double(i), count: i)
            boundAvg.addDataPoint(dataPoint: input)
        }
        XCTAssertEqual(outputData[50].xAccel, 25)
        XCTAssertEqual(outputData[50].yAccel, 25)
        XCTAssertEqual(outputData[50].zAccel, 25)
        
        XCTAssertEqual(outputData[100].xAccel, 50.5)
        XCTAssertEqual(outputData[100].yAccel, 50.5)
        XCTAssertEqual(outputData[100].zAccel, 50.5)

    }
    
    func testMinimumJumpPass(){
        
        let boundAvg = BoundedAverage()
        var outputData = [accelPoint]()
        
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        
        for i in 0...100{
            
            let input = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i)
            
            if i % 2 == 0{
                input.xAccel = 0.11
                input.yAccel = 0.11
                input.zAccel = 0.11
            }else if i % 3 == 0{
                input.xAccel = -0.11
                input.yAccel = -0.11
                input.zAccel = -0.11
            }
            boundAvg.addDataPoint(dataPoint: input)
        }
        
        for i in 0...outputData.count-1{
            if i % 2 == 0{
                XCTAssertEqual(outputData[i].xAccel, 0.11)
                XCTAssertEqual(outputData[i].yAccel, 0.11)
                XCTAssertEqual(outputData[i].zAccel, 0.11)
            }else if i % 3 == 0{
                XCTAssertEqual(outputData[i].xAccel, -0.11)
                XCTAssertEqual(outputData[i].yAccel, -0.11)
                XCTAssertEqual(outputData[i].zAccel, -0.11)
            }else{
                XCTAssertEqual(outputData[i].xAccel, 0.0)
                XCTAssertEqual(outputData[i].yAccel, 0.0)
                XCTAssertEqual(outputData[i].zAccel, 0.0)
            }
        }
    }
    
    func testUpdateParams(){
        let boundAvg = BoundedAverage()
        var outputData = [accelPoint]()
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        
        for i in 0...10{
            let input = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i)
            if i % 2 == 0{
                input.xAccel = 0.11
                input.yAccel = 0.11
                input.zAccel = 0.11
            }else if i % 3 == 0{
                input.xAccel = -0.11
                input.yAccel = -0.11
                input.zAccel = -0.11
            }
            boundAvg.addDataPoint(dataPoint: input)
        }
        for i in 0...outputData.count-1{
            if i % 2 == 0{
                XCTAssertEqual(outputData[i].xAccel, 0.11)
                XCTAssertEqual(outputData[i].yAccel, 0.11)
                XCTAssertEqual(outputData[i].zAccel, 0.11)
            }else if i % 3 == 0{
                XCTAssertEqual(outputData[i].xAccel, -0.11)
                XCTAssertEqual(outputData[i].yAccel, -0.11)
                XCTAssertEqual(outputData[i].zAccel, -0.11)
            }else{
                XCTAssertEqual(outputData[i].xAccel, 0.0)
                XCTAssertEqual(outputData[i].yAccel, 0.0)
                XCTAssertEqual(outputData[i].zAccel, 0.0)
            }
        }
        outputData.removeAll()
        boundAvg.setParameter(parameterName: "upperBound", parameterValue: 0.2)
        boundAvg.setParameter(parameterName: "lowerBound", parameterValue: 0.2)
        for i in 0...10{
            let input = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i)
            if i % 2 == 0{
                input.xAccel = 0.51
                input.yAccel = 0.51
                input.zAccel = 0.51
            }else if i % 3 == 0{
                input.xAccel = -0.51
                input.yAccel = -0.51
                input.zAccel = -0.51
            }
            boundAvg.addDataPoint(dataPoint: input)
        }
        for i in 0...outputData.count-1{
            if i % 2 == 0{
                XCTAssertEqual(outputData[i].xAccel, 0.51)
                XCTAssertEqual(outputData[i].yAccel, 0.51)
                XCTAssertEqual(outputData[i].zAccel, 0.51)
            }else if i % 3 == 0{
                XCTAssertEqual(outputData[i].xAccel, -0.51)
                XCTAssertEqual(outputData[i].yAccel, -0.51)
                XCTAssertEqual(outputData[i].zAccel, -0.51)
            }else{
                XCTAssertEqual(outputData[i].xAccel, 0.0)
                XCTAssertEqual(outputData[i].yAccel, 0.0)
                XCTAssertEqual(outputData[i].zAccel, 0.0)
            }
        }
    }
    
    // For regression testing purposes.
    func testNameCorrect(){
        
        XCTAssertEqual(BoundedAverage().filterName.description, "Bounded Average")
    }
    
    // Test time for filter to initalise
    func testPerformaceSetUp(){
        self.measure {
            let _ = BoundedAverage()
        }
    }
    //Included for comparison, this filter shows trivial time to complete one point calculation
    func testPerformanceSinglePoint() {
        
        let boundAvg = BoundedAverage()
        var count = 0
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            count+=1
        })
        self.measure {
            let pointToAdd = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
            boundAvg.addDataPoint(dataPoint: pointToAdd);
            while(count < 1){
                //Wait for all points to return
                //Timer runs until the point returns
            }
        }
    }
    
    func testPerformanceTenThouPoints(){
        
        let boundAvg = BoundedAverage()
        var count = 0
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            count+=1
        })
        self.measure {
            for i in 0...10000{
                boundAvg.addDataPoint(dataPoint: accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i));
            }
            while(count < 10000){
                //Wait for all points to return
                //Timer runs until all 1000 points return
            }
        }
    }
}
