# Welcome to the README for DataFil!

The purpose of this software is to provide a convenient and reliable set of signal processing tools for developers to integrate into their project to better utilise the suite of sensors provided on an iPhone. 

Creating a filter that has the right characteristics for your application can be an extremely time consuming task, and often requires knowledge of digital signal processing to be effective.

This library provides an alternative to that, with ready to use filters that can be customised and integrated into your application quickly. The filters can be applied to almost any data source from iOS or elsewhere, and have been designed to maximise ease of use for someone with little or no signal processing experience. With this in mind, the key features of the filters include:

* A consistent, easy to use interface and simple data model
* “Drag and drop” functionality. Each filter can operate as a standalone class. No project imports or external dependencies required.
* The latest Swift 3 syntax.
* Concurrent calculations where necessary. 

## Usage

### Standalone Filter

In addition to the chosen filter add the following files to your project:

* `accelPoint`
* `Enumerations`

Here we will use the *high pass* filter.

Initalise the filter:

    let highPass = highPass()
    
(Optional) Adust parameters as desired:

    highPass.setParameter(parameterName: "SampleRate", parameterValue: 30.0)
    
Register a callback:

    let update = {(data: [accelPoint])->Void in {
       for dataItem in data{
          print("Filtered acceleration in X is: \(dataItem.xAccel)")
        }
    }   
    highPass.addObserver(update: update)

Finally, to pass data to the filter to process:
    
    let exampleDataPoint = accelPoint()
    exampleDataPoint.xAccel = 10.0
    highPass.addDataPoint(dataPoint: exampleDataPoint)
    
The filter will now execute the callback registered earlier when it has completed processing the passed in data.

### With Data Source and Filter Manager

Initalise the data source manager, filter manager and start up data sources:

    let dcm = dataSourceManage(sourceId: "John's iPhone")
    
    = FilterManager.sharedInstance()
    dcm.initaliseDatasources()



## See the Wiki for information on how to use this repo 
