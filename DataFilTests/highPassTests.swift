//
//  highPassTests.swift
//  Accelerometer_Graph
//
//  Created by Alex Gubbay on 21/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import XCTest

class highPassTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRingingPresence(){
        
        let highPss = HighPass()
        var outputData = [accelPoint]()
        
        let output = {(data: [accelPoint])->Void in
            
            outputData.append(contentsOf: data)
        }
        
        highPss.addObserver(update: output)
        
        for i in 0...1000{
            let slopeValue = Double(i) * 0.01
            let pointToAdd = accelPoint(dataX: slopeValue, dataY: slopeValue, dataZ: 0.0, count: i)
            highPss.addDataPoint(dataPoint: pointToAdd);
        }
        //confirm that output is near constant and doesnt rise abouve marginal value
        for i in 0...1000{
        
            let current = outputData[i]
            let raw = Double(i) * 0.01
            
            XCTAssertLessThanOrEqual(current.x, raw) //ensure no ringing is present

        }
    }
    
    func testLowFreqAttenuation(){
        
        let highPss = HighPass()
       
        var outputData = [accelPoint]()
        
        let output = {(data: [accelPoint])->Void in
            
            outputData.append(contentsOf: data)
        }
        
        highPss.addObserver(update: output)
        
        for i in 0...100{
            
            let slopeValue = Double(i) * 0.01
            let pointToAdd = accelPoint(dataX: slopeValue, dataY: slopeValue, dataZ: 0.0, count: i)
            
            highPss.addDataPoint(dataPoint: pointToAdd);
        }
    
        for i in 100...100{ //allow time for signal to sabilise
            
            let current = outputData[i]

            //The filtered signal should never be greater than this.
            XCTAssertLessThan(current.x, 0.021)
        }
        
    }
    
    func testHighFreqPass(){
        
        let highPss = HighPass()
        highPss.setParameter(parameterName: "cutoffFrequency", parameterValue: 0.5) // cut off set to level below that of signal
        var outputData = [accelPoint]()
        highPss.addObserver(update: {(data: [accelPoint])->Void in
            outputData.append(contentsOf: data)
        })
        
        for i in 0...1000{
            
            var slopeValue = 0.0
            
            if i % 10 == 0{
                
                slopeValue = 1.0
            }
            let pointToAdd = accelPoint(dataX: slopeValue, dataY: 0.0, dataZ: 0.0, count: i)

            highPss.addDataPoint(dataPoint: pointToAdd);
        }
        
        for i in 1...999{ //prevent out of bounds when checking sums
            
            let current = outputData[i]
            var raw = 0.0
            
            if i % 10 == 0{
                
                raw = 1.0
                var min = current.x
                var max = current.x
                for j in -2...2{
                    if outputData[i+j].x < min {
                        min = outputData[i+j].x
                    }
                    if outputData[i+j].x > max {
                        max = outputData[i+j].x
                    }
                }
                let amplitude = abs(max)+abs(min);
                XCTAssertEqualWithAccuracy(amplitude, 1.0, accuracy: 0.01) //Due to precisison in variables, small amount of amplitude may be lost.
            }
        }
    }
    
    // For regression testing purposes.
    func testNameCorrect(){
        
        XCTAssertEqual(HighPass().getFilterName(), "High Pass")
    }
    
    
    // Test time for filter to initalise
    func testPerformaceSetUp(){
        
        self.measure {
            let _ = HighPass()
        }
        
    }
    
    //Included for comparison, this filter shows trivial time to complete one point calculation
    func testPerformanceSinglePoint() {
        
        let highPss = HighPass()
        var count = 0
        highPss.addObserver(update: {(data: [accelPoint])->Void in
            count+=1
        })
        
        self.measure {
           
            let pointToAdd = accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: 0)
            highPss.addDataPoint(dataPoint: pointToAdd);
            
            while(count < 1){
                
                //Wait for all points to return
                //Timer runs until the point returns
                
            }
            
        }
    }
    
    func testPerformanceTenThouPoints(){
        
        let highPss = HighPass()
        var count = 0
        highPss.addObserver(update: {(data: [accelPoint])->Void in
            count+=1
        })
    
        self.measure {
        
            for i in 0...10000{
                
                highPss.addDataPoint(dataPoint: accelPoint(dataX: 0.0, dataY: 0.0, dataZ: 0.0, count: i));
                
            }
            while(count < 10000){
                //Wait for all points to return
                //Timer runs until all 1000 points return
            }
            
        }
    }
    
}
