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
        
        let boundAvg = boundedAverage()
        var outputData = [accelPoint]()
        
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        
        for i in 0...100{
            
            let input = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i)
            
            if i % 2 == 0{
                
                input.x = 0.09
                input.y = 0.09
                input.z = 0.09
                
            }
            boundAvg.addDataPoint(dataPoint: input)
        }
        
        for point in outputData{
            XCTAssertEqual(point.x, 0.0)
            XCTAssertEqual(point.y, 0.0)
            XCTAssertEqual(point.z, 0.0)
        }
    }
    
    func testAverage(){
        
        let boundAvg = boundedAverage()
        boundAvg.setParameter(parameterName: "points", parameterValue: 100)
        var outputData = [accelPoint]()
        
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        
        for i in 0...100{
            
            let input = accelPoint(dataX: Double(i), dataY: Double(i), dataZ: Double(i), count: i)
            boundAvg.addDataPoint(dataPoint: input)
        }
        XCTAssertEqual(outputData[50].x, 25)
        XCTAssertEqual(outputData[50].y, 25)
        XCTAssertEqual(outputData[50].z, 25)
        
        XCTAssertEqual(outputData[100].x, 50)
        XCTAssertEqual(outputData[100].y, 50)
        XCTAssertEqual(outputData[100].z, 50)

    }
    
    func testMinimumJumpPass(){
        
        let boundAvg = boundedAverage()
        var outputData = [accelPoint]()
        
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        
        for i in 0...100{
            
            let input = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i)
            
            if i % 2 == 0{
                input.x = 0.11
                input.y = 0.11
                input.z = 0.11
            }else if i % 3 == 0{
                input.x = -0.11
                input.y = -0.11
                input.z = -0.11
            }
            boundAvg.addDataPoint(dataPoint: input)
        }
        
        for i in 0...outputData.count-1{
            if i % 2 == 0{
                XCTAssertEqual(outputData[i].x, 0.11)
                XCTAssertEqual(outputData[i].y, 0.11)
                XCTAssertEqual(outputData[i].z, 0.11)
            }else if i % 3 == 0{
                XCTAssertEqual(outputData[i].x, -0.11)
                XCTAssertEqual(outputData[i].y, -0.11)
                XCTAssertEqual(outputData[i].z, -0.11)
            }else{
                XCTAssertEqual(outputData[i].x, 0.0)
                XCTAssertEqual(outputData[i].y, 0.0)
                XCTAssertEqual(outputData[i].z, 0.0)
            }
        }
    }
    
    func testUpdateParams(){
    
        let boundAvg = boundedAverage()
        var outputData = [accelPoint]()
        
        boundAvg.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        
        for i in 0...10{
            
            let input = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i)
            
            if i % 2 == 0{
                input.x = 0.11
                input.y = 0.11
                input.z = 0.11
            }else if i % 3 == 0{
                input.x = -0.11
                input.y = -0.11
                input.z = -0.11
            }
            boundAvg.addDataPoint(dataPoint: input)
        }
        
        for i in 0...outputData.count-1{
            if i % 2 == 0{
                XCTAssertEqual(outputData[i].x, 0.11)
                XCTAssertEqual(outputData[i].y, 0.11)
                XCTAssertEqual(outputData[i].z, 0.11)
            }else if i % 3 == 0{
                XCTAssertEqual(outputData[i].x, -0.11)
                XCTAssertEqual(outputData[i].y, -0.11)
                XCTAssertEqual(outputData[i].z, -0.11)
            }else{
                XCTAssertEqual(outputData[i].x, 0.0)
                XCTAssertEqual(outputData[i].y, 0.0)
                XCTAssertEqual(outputData[i].z, 0.0)
            }
        }
        
        outputData.removeAll()
        
        boundAvg.setParameter(parameterName: "upperBound", parameterValue: 0.2)
        boundAvg.setParameter(parameterName: "lowerBound", parameterValue: 0.2)
        
        for i in 0...10{
            
            let input = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i)
            
            if i % 2 == 0{
                input.x = 0.51
                input.y = 0.51
                input.z = 0.51
            }else if i % 3 == 0{
                input.x = -0.51
                input.y = -0.51
                input.z = -0.51
            }
            boundAvg.addDataPoint(dataPoint: input)
        }
        
        
        for i in 0...outputData.count-1{
            if i % 2 == 0{
                XCTAssertEqual(outputData[i].x, 0.51)
                XCTAssertEqual(outputData[i].y, 0.51)
                XCTAssertEqual(outputData[i].z, 0.51)
            }else if i % 3 == 0{
                XCTAssertEqual(outputData[i].x, -0.51)
                XCTAssertEqual(outputData[i].y, -0.51)
                XCTAssertEqual(outputData[i].z, -0.51)
            }else{
                XCTAssertEqual(outputData[i].x, 0.0)
                XCTAssertEqual(outputData[i].y, 0.0)
                XCTAssertEqual(outputData[i].z, 0.0)
            }
        }
        
        

        
    }
    
    // For regression testing purposes.
    func testNameCorrect(){
        
        XCTAssertEqual(boundedAverage().getFilterName(), "Bounded Average")
    }
    
    
    // Test time for filter to initalise
    func testPerformaceSetUp(){
        
        self.measure {
            let _ = boundedAverage()
        }
        
    }
    
    //Included for comparison, this filter shows trivial time to complete one point calculation
    func testPerformanceSinglePoint() {
        
        let boundAvg = boundedAverage()
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
        
        let boundAvg = boundedAverage()
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
