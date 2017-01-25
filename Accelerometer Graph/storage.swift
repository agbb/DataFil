//
//  storage.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 21/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation
import CoreData

class storage{
    
    
    func fetchRecordings() -> [(Date: Date,csv: String, json: String)]{
    
        var recordings = [(Date,String,String)]()
        
        let managedContext = persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Recording")
        
        do{
            let recordingArrayFromPersistent = try managedContext.fetch(fetch)
            
            for record in recordingArrayFromPersistent as [NSManagedObject]{
                
                let triggerData = record.value(forKey: "triggerTime") as! Date
                let jsonData = record.value(forKey: "jsonString") as? String ?? "NO DATA"
                let csvData = record.value(forKey: "csvString") as? String ?? "NO DATA"
                let newTuple = (triggerData , csvData , jsonData )
                
                recordings.append(newTuple)
            }
        }catch{
            print("error fetching")
        }
        return recordings
    }
    
    
    func saveRecordingJson(json: JSON, triggerTime:Date){
        
        
        let jsonString = json.rawString([.castNilToNSNull: true])
        
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recording", in: managedContext)
        let recording = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        recording.setValue(triggerTime, forKey: "triggerTime")
        recording.setValue(jsonString, forKey: "jsonString")

        do {
            try managedContext.save()
        }catch{
            print("save failed")
        }
        
        
    }
    
    func saveRecordingCsv(csv: String, triggerTime:Date){
        
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recording", in: managedContext)
        let recording = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        recording.setValue(triggerTime, forKey: "triggerTime")
        recording.setValue(csv, forKey: "csvString")

        
        do {
            try managedContext.save()
        }catch{
            print("save failed")
        }
    }
    
    func fetchRecordingWithDate(date:Date) -> (date: Date,json: String, csv: String){
        
        
        let managedContext = persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Recording")
        fetch.predicate = NSPredicate(format: "triggerTime == %@", date as CVarArg)
        fetch.fetchLimit = 1
        do{
            let recordingArrayFromPersistent = try managedContext.fetch(fetch)
            let record = recordingArrayFromPersistent[0]
            
            let triggerData = record.value(forKey: "triggerTime") as! Date
            
            let jsonData = record.value(forKey: "jsonString") as? String ?? "NO DATA"
            let csv = record.value(forKey: "csvString") as? String ?? "NO DATA"
            
            
            return (date:triggerData, json:jsonData, csv:csv)
        }catch{
            print("error fetching")
        }
        return (date:Date(), json:"NO DATA", csv:"NO DATA")
    }
    
    
    func removeRecordingWithDate(date:Date) {
        
        let managedContext = persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Recording")
        fetch.predicate = NSPredicate(format: "triggerTime == %@", date as CVarArg)
        fetch.fetchLimit = 1
        do{
            let recordingArrayFromPersistent = try managedContext.fetch(fetch)
            let record = recordingArrayFromPersistent[0]
            managedContext.delete(record)
        }catch{
            print("error fetching")
        }
    }

}
