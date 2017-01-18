//
//  recorder.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 18/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation
import UIKit

class recorder{
    
    var raw = false
    var processed = false
    var time = 0.0
   
    
    func beginRecording(raw: Bool, processed: Bool, time: Double, complete: () -> Void){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.newRawData), name: Notification.Name("newRawData"), object: nil)

    
    }
    
     @objc func newRawData(notification: NSNotification){
        print("boop")
       // let data = notification.userInfo as! Dictionary<String,accelPoint>
       // let accelData = data["data"]
        
        
    }
    
    @objc func newProcessedDataForRecord(notification: NSNotification){
        
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]
        
        
    }
    
    
    func saveRecording(){
    
    }
}
