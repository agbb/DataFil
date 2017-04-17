//
//  storage.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 21/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import Foundation
import CoreData
/**
 Manages the storage and retreival of recorded captures from disk. Utilises CoreStorage.
 */
class Storage{
    /**
        Retrives all records from disk.
        - returns: An array of tuples: `(Date: Date,csv: String, json: String)`
     */
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
    /**
        Saves JSON recording to disk.
        - parameter json: JSON object to save
        - parameter triggerTime: Date object created at the start of the recording. Used to idntify.
     */
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
    
    /**
     Saves csv recording to disk.
     - parameter csv: csv object to save
     - parameter triggerTime: Date object created at the start of the recording. Used to idntify.
     */
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
    
    /**
        Returns a recording with a matching triggerTime, as set using `saveRecordingJson` or `saveRecordingCsv` when persisting to disk.
        - parameter date: TriggerTime of the recording to return.
        - returns: A tuple: `(date: Date,json: String, csv: String)` if the recording exists, will be of the format: `(date:Date(), json:"NO DATA", csv:"NO DATA")` if not.
     */
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
    
    /**
     Deletes a recording for persistent storage.
     - parameter date: The triggerTime of the recording to delete.
     */
    func removeRecordingWithDate(date:Date) {
        
        do{
            let managedContext = persistentContainer.viewContext
            let fetch = NSFetchRequest<NSManagedObject>(entityName: "Recording")
            fetch.predicate = NSPredicate(format: "triggerTime == %@", date as CVarArg)
            fetch.fetchLimit = 1
            let recordingArrayFromPersistent = try managedContext.fetch(fetch)
            print(recordingArrayFromPersistent.count)
            let record = recordingArrayFromPersistent[0]
            managedContext.delete(record)
            try managedContext.save()
        }catch{
            print("error fetching")
        }
    }
}
