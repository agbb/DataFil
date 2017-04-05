//
//  enumerations.swift
//  DataFil
//
//  Created by Alex Gubbay on 05/04/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import Foundation

/**
 Enumeration of the filter algorithms available in the library
 */
enum Algorithm{
    
    case HighPass
    case LowPass
    case BoundedAverage
    case TotalVariation
    case SavitzkyGolay
}
