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
        
        var csv = "ID,rawX,rawY,rawZ,processedX,processedY,processedZ"
        if(rawData.count != processedData.count){
            print("RECORDINGS NOT SAME LENGTH: CLIPPING TO SHORTEST")
        }
        let paired = zip(rawData, processedData)

        
        for pair in paired{
          csv = csv + "\n\(pair.0.count),\(pair.0.x),\(pair.0.y),\(pair.0.z),\(pair.1.x),\(pair.1.y),\(pair.1.z)"
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
        print(json)
        return json
        
    }
    
    func formatJSONdata(header: JSON, rawData: [accelPoint], processedData: [accelPoint]) -> JSON{
        var workingJSON = header
        
        
        var rawPoints = [[String:Double]]()
        var processedPoints = [[String:Double]]()
        
        for point in rawData{
            var pointDict = [String:Double]()
            pointDict["ID"] = Double(point.count)
            pointDict["x"] = point.x
            pointDict["y"] = point.y
            pointDict["z"] = point.z
            rawPoints.append(pointDict)
            
        }
        
        for point in processedData{
            var pointDict = [String:Double]()
            pointDict["ID"] = Double(point.count)
            pointDict["x"] = point.x
            pointDict["y"] = point.y
            pointDict["z"] = point.z
            processedPoints.append(pointDict)
        }
        
        workingJSON["raw"] = JSON(rawPoints)
        workingJSON["processed"] = JSON(processedPoints)
        
        return workingJSON
        
        
    }

    
}
