//
//  recorder.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 18/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class recorder{
    
    private var rawData = [accelPoint]()
    private var processedData = [accelPoint]()
    private var triggerTime = NSDate()
    private var rawRecordingPoint = 0
    private var processedRecordingPoint = 0
    private var exportAsJson = true
    private let formatter = dataFormatter()
    
    func beginRecording(raw: Bool, processed: Bool, time: Double, json: Bool){
        triggerTime = NSDate()
        exportAsJson = json
        
        if raw{
            NotificationCenter.default.addObserver(self, selector: #selector(self.newRawData), name: Notification.Name("newRawData"), object: nil)
        }
        if processed {
            NotificationCenter.default.addObserver(self, selector: #selector(self.newProcessedData), name: Notification.Name("newProcessedData"), object: nil)
        }
        
        Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: {_ in
            //fire stopRecording method at end of time period
            self.stopRecording()
            
            })
    }
    
     @objc func newRawData(notification: NSNotification){
       let data = notification.userInfo as! Dictionary<String,accelPoint>
       let accelData = data["data"]
       
        accelData?.count = rawRecordingPoint
         rawRecordingPoint += 1
        
        rawData.append(accelData!)
        
    }
    
    private func stopRecording(){

        NotificationCenter.default.removeObserver(self)
 
        if(exportAsJson){
            
            let jsonHeader = formatter.formatJSONheader(triggerTime: triggerTime as Date)
            let outputData = formatter.formatJSONdata(header: jsonHeader, rawData: rawData, processedData: processedData)
            storage().saveRecordingJson(json: outputData, triggerTime: triggerTime as Date)
        }else{
            
            let csvString = formatter.formatCSV(rawData: rawData, processedData: processedData)
            storage().saveRecordingCsv(csv: csvString, triggerTime: triggerTime as Date)
            
        }
        
    }
    
    @objc func newProcessedData(notification: NSNotification){
        let data = notification.userInfo as! Dictionary<String,[accelPoint]>
        let accelData = data["data"]
        for point in accelData! {
            
            point.count = processedRecordingPoint
            processedRecordingPoint += 1
            processedData.append(point)
        }
}
    
   
    
  deinit{
        //clean up observers
        NotificationCenter.default.removeObserver(self)
    }
}
