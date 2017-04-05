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

/**
 Responsible for capturing raw, filtered and remote data from the data publishers. 
 */
class Recorder{
    
    private var rawData = [accelPoint]()
    private var processedData = [accelPoint]()
    private var rawRecordingPoint = 0
    private var processedRecordingPoint = 0
    private var exportAsJson = true
    private let formatter = DataFormatter()
    
    /**
     starts recording data published from data sources.
     - parameter raw: Should capture raw data.
     - parameter processed: Should capture processed data.
     - parameter time: Duration of recording.
     - parameter json: Should save as JSON.
     - parameter fromWatch: Capture data from remote watch.
     */
    func beginRecording(raw: Bool, processed: Bool, time: Double, json: Bool, fromWatch: Bool){
        let triggerTime = NSDate()
        print("starting")
        exportAsJson = json
        if !fromWatch{
            if raw{
                NotificationCenter.default.addObserver(self, selector: #selector(self.newRawData), name: Notification.Name("newRawData"), object: nil)
            }
            if processed {
                NotificationCenter.default.addObserver(self, selector: #selector(self.newProcessedData), name: Notification.Name("newProcessedData"), object: nil)
            }
        }else{
            if raw{
                NotificationCenter.default.addObserver(self, selector: #selector(self.newRawData), name: Notification.Name("newRemoteData"), object: nil)
            }
            if processed {
                NotificationCenter.default.addObserver(self, selector: #selector(self.newProcessedData), name: Notification.Name("newRemoteProcessedData"), object: nil)
            }
        }
        Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: {_ in
            //fire stopRecording method at end of time period
            self.stopRecording(triggerTime: triggerTime, fromWatch: fromWatch)
            
            })
    }
    
     @objc private func newRawData(notification: NSNotification){
        print(notification.name)
       let data = notification.userInfo as! Dictionary<String,accelPoint>
       let accelData = data["data"]
        accelData?.count = rawRecordingPoint
         rawRecordingPoint += 1
        
        rawData.append(accelData!)
        
    }
    /**
     Called to end the recording. Triggers the process of writing to disk.
     - parameter triggerTime: The time under which to save the recording
     - parameter fromWatch: Defines if the recorded data came from the watch.
     */
    private func stopRecording(triggerTime: NSDate, fromWatch: Bool){

        NotificationCenter.default.removeObserver(self)
        print(rawData.count)
        if(exportAsJson){
            
            let jsonHeader = formatter.formatJSONheader(triggerTime: triggerTime as Date, fromWatch: fromWatch)
            let outputData = formatter.formatJSONdata(header: jsonHeader, rawData: rawData, processedData: processedData)
            Storage().saveRecordingJson(json: outputData, triggerTime: triggerTime as Date)
        }else{
            
            let csvString = formatter.formatCSV(rawData: rawData, processedData: processedData)
            Storage().saveRecordingCsv(csv: csvString, triggerTime: triggerTime as Date)
            
        }
       rawData.removeAll(keepingCapacity: false)
        rawRecordingPoint = 0
        processedRecordingPoint = 0
    }
    
    
    
    
    
    @objc private func newProcessedData(notification: NSNotification){
        
        print(notification.name)
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
