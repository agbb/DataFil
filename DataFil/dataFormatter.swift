//
//  dataFormatter.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 25/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

class dataFormatter {
    
    func formatCSV(rawData: [accelPoint], processedData: [accelPoint]) -> String{
        var outputRaw = rawData
        var outputProcessed = processedData

        var point = 0
        if rawData.count > 0 {
            point = rawData[rawData.count - 1].count
        }
        while outputRaw.count < outputProcessed.count{
            print("adding raw")
            point += 1
            outputRaw.append(accelPoint(dataX: 0, dataY: 0, dataZ: 0, count: point))
        }
        
        point = 0 
        if processedData.count > 0 {
            point = processedData[processedData.count - 1].count
        }
        while outputProcessed.count < outputRaw.count{
            print("adding processed")
            point += 1
            outputProcessed.append(accelPoint(dataX: 0, dataY: 0, dataZ: 0, count: point))
        }
 
        var csv = "ID,rawXAccel,rawYAccel,rawZAccel,rawXGyro,rawYGyro,rawZGyro,rawXMag,rawYMag,rawZMag,processedXAccel,processedYAccel,processedZAccel,processedXGyro,processedYGyro,processedZGyro,processedXMag,processedYMag,processedZMag"
        if(outputRaw.count != outputProcessed.count){
            print("RECORDINGS NOT SAME LENGTH: CLIPPING TO SHORTEST")
        }
        let paired = zip(outputRaw, outputProcessed)

        
        for pair in paired{
            csv = csv + "\n\(pair.0.count),\(pair.0.xAccel),\(pair.0.yAccel),\(pair.0.zAccel),\(pair.0.xGyro),\(pair.0.yGyro),\(pair.0.zGyro),\(pair.0.xMag),\(pair.0.yMag),\(pair.0.zMag),"
            
            csv = csv + "\(pair.1.xAccel),\(pair.1.yAccel),\(pair.1.zAccel),\(pair.1.xGyro),\(pair.1.yGyro),\(pair.1.zGyro),\(pair.1.xMag),\(pair.1.yMag),\(pair.1.zMag)"
        }
    
        return csv
    }
    
    func formatJSONheader(triggerTime: Date, fromWatch: Bool)-> JSON{
        
        
        let dateFormatter = utilities.dateFormatter
        
        var dateString = "{\"date\" : \""+dateFormatter.string(from: triggerTime as Date)+"\"}"
        if fromWatch{
            dateString = "{\"date\" : \""+dateFormatter.string(from: triggerTime as Date)+"\"}"
        }
        let dateJson = dateString.data(using: .utf8, allowLossyConversion: false)
    
        
        var json = JSON(data: dateJson!)
        let filters = FilterManager.sharedInstance.activeFilters
        var filterData = [String:[String:Double]]()
        for filter in filters{
            filterData[filter.filterName] = filter.params
        }
        json["filters"] = JSON(filterData)
        if fromWatch {
            json["source"] = JSON("Watch")
        }else{
            json["source"] = JSON("iPhone or iPad")
        }
        return json
        
    }
    
    func formatJSONdata(header: JSON, rawData: [accelPoint], processedData: [accelPoint]) -> JSON{
        var workingJSON = header
        
        
        var rawPoints = [[String:Double]]()
        var processedPoints = [[String:Double]]()
        
        for point in rawData{
            var pointDict = [String:Double]()
            pointDict["ID"] = Double(point.count)
            pointDict["xAccel"] = point.xAccel
            pointDict["yAccel"] = point.yAccel
            pointDict["zAccel"] = point.zAccel
            pointDict["xGyro"] = point.xGyro
            pointDict["yGyro"] = point.yGyro
            pointDict["zGyro"] = point.zGyro
            pointDict["xMag"] = point.xMag
            pointDict["yMag"] = point.yMag
            pointDict["zMag"] = point.zMag
            
            rawPoints.append(pointDict)
            
        }
        
        for point in processedData{
            var pointDict = [String:Double]()
            pointDict["ID"] = Double(point.count)
            pointDict["xAccel"] = point.xAccel
            pointDict["yAccel"] = point.yAccel
            pointDict["zAccel"] = point.zAccel
            pointDict["xGyro"] = point.xGyro
            pointDict["yGyro"] = point.yGyro
            pointDict["zGyro"] = point.zGyro
            pointDict["xMag"] = point.xMag
            pointDict["yMag"] = point.yMag
            pointDict["zMag"] = point.zMag
            processedPoints.append(pointDict)
        }
        
        workingJSON["raw"] = JSON(rawPoints)
        workingJSON["processed"] = JSON(processedPoints)
        
        return workingJSON
        
        
    }

    
}
