//
//  globalConfig.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 20/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation

struct notificationManager{
    static var nc = NotificationCenter.default
    static let newRawDataNotification = Notification.Name("newRawData")
}


extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence

func ^^ (first: Double, second: Double) -> Double {
    return pow(Double(first), Double(second))
}
