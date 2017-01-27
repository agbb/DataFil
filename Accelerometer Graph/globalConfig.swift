//
//  globalConfig.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 20/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation
import UIKit
import CoreData


struct utilities{
    static var dateFormatter = DateFormatter()
    static var nc = NotificationCenter.default
    static let newRawDataNotification = Notification.Name("newRawData")
    static var singleView = true
    static var pointCount = 300
    
    init() {
        utilities.dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss '+'ZZZZ"
        utilities.dateFormatter.timeStyle = .full
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "Model")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error {
            
            fatalError("Unresolved error with the persistent container")
        }
    })
    return container
}()

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence

func ^^ (first: Double, second: Double) -> Double {
    return pow(Double(first), Double(second))
}

struct alertBuilder{
    
    func build(title: String,  message:String, buttonText:String)-> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}
