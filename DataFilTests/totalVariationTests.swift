//
//  totalVariationTests.swift
//  DataFil
//
//  Created by Alex Gubbay on 04/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import XCTest

class totalVariationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCalculation() {
        let totalVar = TotalVariationWrapper()
        var outputData = [accelPoint]()
        
        let output = {(data: [accelPoint])->Void in
            
            outputData.append(contentsOf: data)
        }
        
        totalVar.addObserver(update: output)
        
        for i in 0...1001{
            //let slopeValue = Double(i) * 0.01
            let slope1 = Double(i).truncatingRemainder(dividingBy: 3)
            let slope2 = Double(i).truncatingRemainder(dividingBy: 2)
            let slopeValue = slope1 + slope2
            let pointToAdd = accelPoint(dataX: slopeValue, dataY: slopeValue, dataZ: 0.0, count: i)
            totalVar.addDataPoint(dataPoint: pointToAdd);
        }
        //confirm that output is near constant and doesnt rise abouve marginal value
        for i in 0..<1000{
            
            let current = outputData[i]
            let slope1 = Double(i).truncatingRemainder(dividingBy: 3)
            let slope2 = Double(i).truncatingRemainder(dividingBy: 2)
            let slopeValue = slope1 + slope2
            //XCTAssertLessThanOrEqual(current.xAccel, slopeValue) //ensure no ringing is present
            
        }
    }
    
    func testCalculationPyramid() {
        let totalVar = TotalVariationWrapper()
        totalVar.setParameter(parameterName: "lambda", parameterValue: 10.0)
        var outputData = [accelPoint]()
        
        let output = {(data: [accelPoint])->Void in
            
            outputData.append(contentsOf: data)
        }
        
        totalVar.addObserver(update: output)
        
        for i in 0...1001{
            //let slopeValue = Double(i) * 0.01
            
            var slopeValue = 0.0
            if i < 500{
                slopeValue = Double(i)
            }else{
                slopeValue = 500 - (Double(i) - 500)
            }
            let pointToAdd = accelPoint(dataX: slopeValue, dataY: slopeValue, dataZ: 0.0, count: i)
            totalVar.addDataPoint(dataPoint: pointToAdd);
        }
        //confirm that output is near constant and doesnt rise abouve marginal value
        for i in 0..<1000{
            
            let current = outputData[i]
            var slopeValue = 0.0
            if i < 500{
                slopeValue = Double(i)
            }else{
                slopeValue = 500 - (Double(i) - 500)
            }
            XCTAssertEqualWithAccuracy(current.xAccel, slopeValue, accuracy: 1.5)
        }
    }
    
    func testRawData(){
        
        guard let inputPath = Bundle.main.path(forResource: "testData", ofType: "txt")
            else {
                print("cant read input file")
                XCTAssertFalse(true)
                return
        }
        do {
            
            guard let outputPath = Bundle.main.path(forResource: "testOutput", ofType: "txt")
                else {
                    print("cant read output file")
                    XCTAssertFalse(true)
                    return
            }
            do {
                let totalVar = TotalVariationWrapper()
                totalVar.setParameter(parameterName: "lambda", parameterValue: 10.0)
                totalVar.setParameter(parameterName: "bufferSize", parameterValue: 10.0)
                var outputData = [accelPoint]()
                
                let outputClosure = {(data: [accelPoint])->Void in
                    outputData.append(contentsOf: data)
                }
                
                totalVar.addObserver(update: outputClosure)
                let inputContents = try String(contentsOfFile: inputPath)
                let inputStrings = inputContents.components(separatedBy: "\n")
                var inputPoints = [accelPoint]()
                
                for num in 0..<inputStrings.count-1{
                    
                    let doubleNum = Double(inputStrings[num])
                    let point = accelPoint(dataX: doubleNum!, dataY: doubleNum!, dataZ: doubleNum!, count: num)
                    inputPoints.append(point)
                    totalVar.addDataPoint(dataPoint: point)

                }
                
                let outputContents = try String(contentsOfFile: outputPath)
                let outputStrings = outputContents.components(separatedBy: "\n")
                var outputPoints = [accelPoint]()
                for num in 0..<outputStrings.count-1{
                    let doubleNum = Double(outputStrings[num])
                    let point = accelPoint(dataX: doubleNum!, dataY: doubleNum!, dataZ: doubleNum!, count: num)
                    outputPoints.append(point)
                }
                for i in 0..<outputData.count{
                    XCTAssertEqualWithAccuracy(outputData[i].xAccel, outputPoints[i].xAccel,accuracy: 0.001)
                }
            }catch {
                print("File Read Error for file \(outputPath)")
                XCTAssertFalse(true)
            }
        } catch {
            print("File Read Error for file \(inputPath)")
            XCTAssertFalse(true)
        }
    }
}
