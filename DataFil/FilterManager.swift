//
//  FilterManager.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 09/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import Foundation

/**
 Class that controls the data flow through filters. When initalised, it will begin listening for data from the DataSourceManager class, published under the `newRawData` notifcation.
 */

class FilterManager{
    
    static let sharedInstance = FilterManager()
    var activeFilters = [Filter]()
    
    init(){

        NotificationCenter.default.addObserver(self, selector: #selector(FilterManager.newRawData), name: Notification.Name("newRawData"), object: nil)

    }
    
    /**
     Called when a notification under "newRawData" key arrives, as registered in the constructor.
     */
    @objc func newRawData(notification: NSNotification){
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]
        //let currentData = accelData?.getAxis(axis: "x")
        if activeFilters.count >= 1 {
            activeFilters[0].addDataPoint(dataPoint: accelData!)
        }else{ //no filters, direct input straight to output
            receiveData(data: [accelData!], id: -1)
        }
        
    }
    
    /**
     Enables the filter algorithm passed into the method, causing the "newProcessesData" notification to begin posting the output of the raw data after convoultion with this filter and any others enabled.
     
     - parameter algorithmToEnable: Value of the Algorithm enum, which will be one of the included filter algorithms.
     */
    func addNewFilter(algorithmToEnable: Algorithm){
        
        switch algorithmToEnable {
        case .HighPass:
            let highPass = HighPass()
            highPass.id = activeFilters.count
            
            let update = {(data: [accelPoint])->Void in
                
                self.receiveData(data: data, id: highPass.id)
            }
            
            highPass.addObserver(update: update)
            activeFilters.append(highPass)
            break
        case .LowPass:
            let lowPass = advancedLowPass()
            lowPass.id = activeFilters.count
            
            let update = {(data: [accelPoint])->Void in
                
                self.receiveData(data: data, id: lowPass.id)
            }
            
            lowPass.addObserver(update: update)
            activeFilters.append(lowPass)
            break
        case .BoundedAverage:
            let boundedAvg = boundedAverage()
            boundedAvg.id = activeFilters.count
            
            let update = {(data: [accelPoint])->Void in
                
                self.receiveData(data: data, id: boundedAvg.id)
            }
            
            boundedAvg.addObserver(update: update)
            activeFilters.append(boundedAvg)
            break
        case .SavitzkyGolay:
            let savgolay = SavitzkyGolay()
            let update = {(data: [accelPoint])->Void in
                
                self.receiveData(data: data, id: savgolay.id)
            }
            savgolay.addObserver(update: update)
            activeFilters.append(savgolay)
            break
        case .TotalVariation:
           let tvd = TotalVariationWrapper()
           let update = {(data: [accelPoint])->Void in
            
            self.receiveData(data: data, id: tvd.id)
           }
           tvd.addObserver(update: update)
           activeFilters.append(tvd)
            break
        }
        
    }
    
    /**
     Removes the fitler from the data flow, causing the output of "newProcessedData" to be the convoluted output of the raw data and any remaining filters. If none, then the raw data will be outputted.
     - parameter filterName: Name of the filter algorithm to remove.
     */
    func removeFilter(name: Algorithm){
        for i in 0 ..< activeFilters.count{
            if activeFilters[i].filterName == name{
                activeFilters.remove(at: i)
                break;
            }
        }
    }

    /**
     Function to retreive a filter object that with the matching name.
     - parameter name: Name of the filter to return.
     - returns: The named filter, if it is enabled. Nill if not.
     */
    private func getFilterByName(name: Algorithm) -> Filter?{
        for filter in activeFilters{
            if filter.filterName == name{
            return filter
            }
        }
        return nil
    }
    
    /**
     Function for setting a parameter of an enabled filter.
     - parameter filterName: Name of the filter whos parameter to set.
     - parameter parameterName: Name of the parameter to set.
     - parameter parameterValue: Value of the parameter to set.
     */
    func setFilterParameter(filterName: Algorithm, parameterName: String, parameterValue: Double){
        getFilterByName(name: filterName)?.setParameter(parameterName: parameterName, parameterValue: parameterValue)
    }
    
    /**
     Function called by each active filter to deliver its output. Will decide if the output data needs to be passed onto another filter, or outputted through the "newProcessedData" notification.
     */
    private func receiveData(data: [accelPoint], id:Int){

        
        if(id >= activeFilters.count-1){ //Possible for data from dedacitvated filters to arrive asynchronusly

            NotificationCenter.default.post(name: Notification.Name("newProcessedData"), object: nil, userInfo:["data":data])
        }else{
            for dataPoint in data{
                activeFilters[id+1].addDataPoint(dataPoint: dataPoint)
            }
        }
        
    }
}
