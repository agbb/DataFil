//
//  enumerations.swift
//  DataFil
//
//  Created by Alex Gubbay on 05/04/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
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
    
    
    var description : String {
        
        switch self {
        case .HighPass: return "High Pass";
        case .LowPass: return "Low Pass";
        case .BoundedAverage: return "Bounded Average";
        case .TotalVariation: return "Total Variation Denoising";
        case .SavitzkyGolay: return "Savitzky Golay Filter";
        }
    }
}


