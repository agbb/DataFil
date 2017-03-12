//
//  serialiser.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

class serialiser {

    init() {

    }

    func serialise(input: accelPoint) -> String{

        return "\(input.count),\(input.x),\(input.y),\(input.z)"
    }

    func deserialise(input: String) -> accelPoint{

        let parts = input.components(separatedBy: ",")
        let outputPoint = accelPoint(dataX: Double.greatestFiniteMagnitude, dataY: Double.greatestFiniteMagnitude, dataZ: Double.greatestFiniteMagnitude, count: -1)
        if parts.count != 4 {
            print("invalid string passed into deserialiser")
            return outputPoint
        }else{
            outputPoint.count = Int(parts[0])!
            outputPoint.x = Double(parts[1])!
            outputPoint.y = Double(parts[2])!
            outputPoint.z = Double(parts[3])!
            return outputPoint
        }

    }
}
