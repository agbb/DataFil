//
//  serialiser.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import Foundation

class Serialiser {

    init() {

    }

    /**
     Takes accelPoint object and returns a serialised String.
     - parameter input: The accelPoint object to be serialised.
     - returns: Serialised version of input accelPoint.
     - complexity: O(1) Time
     */
    func serialise(input: accelPoint) -> String{

        return "\(input.count),\(input.xAccel),\(input.yAccel),\(input.zAccel)"
    }

    /**
     Takes serialised accelPoint string and returns accelPoint object with same information.
     - parameter input: String to be deserialised.
     - returns: accelPoint object deserialised from the String.
     - complexity: O(1) Time
     */
    func deserialise(input: String) -> accelPoint{

        let parts = input.components(separatedBy: ",")
        let outputPoint = accelPoint(dataX: Double.greatestFiniteMagnitude, dataY: Double.greatestFiniteMagnitude, dataZ: Double.greatestFiniteMagnitude, count: -1)
        if parts.count != 4 {
            print("invalid string passed into deserialiser")
            return outputPoint
        }else{
            outputPoint.count = Int(parts[0])!
            outputPoint.xAccel = Double(parts[1])!
            outputPoint.yAccel = Double(parts[2])!
            outputPoint.zAccel = Double(parts[3])!
            return outputPoint
        }

    }
}
