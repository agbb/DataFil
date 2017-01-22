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
    
    
    func fetchRecordings() -> [(Date: Date,String: String)]{
    
        var recordings = [(Date,String)]()
        
        let managedContext = persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Recording")
        
        do{
            let recordingArrayFromPersistent = try managedContext.fetch(fetch)
            
            for record in recordingArrayFromPersistent as [NSManagedObject]{
                
                let triggerData = record.value(forKey: "triggerTime") as! Date
                let jsonData = record.value(forKey: "jsonString") as! String
                let newTuple = (triggerData , jsonData)
                
                recordings.append(newTuple)
            }
        }catch{
            print("error fetching")
        }
        return recordings
    }
    
    
    func saveRecording(json: JSON, triggerTime:Date){
        
        
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
    
    func fetchRecordingWithDate(date:Date) -> (Date: Date,String: String){
        
        
        let managedContext = persistentContainer.viewContext
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Recording")
        fetch.predicate = NSPredicate(format: "triggerTime == %@", date as CVarArg)
        fetch.fetchLimit = 1
        do{
            let recordingArrayFromPersistent = try managedContext.fetch(fetch)
            let record = recordingArrayFromPersistent[0]
            
            let triggerData = record.value(forKey: "triggerTime") as! Date
            let jsonData = record.value(forKey: "jsonString") as! String
            return (Date:triggerData , String:jsonData)
        }catch{
            print("error fetching")
        }
        return (Date:Date() , String:"NO DATA")
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
