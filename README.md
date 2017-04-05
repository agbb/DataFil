# DataFil - A Complete Signal Processing Toolkit for iOS

A convenient and reliable set of signal processing tools for developers to integrate into their project to better utilise the sensors on an iPhone. 

Creating a filter that has the right characteristics for your application can be an extremely time consuming task, and often requires knowledge of signal processing to be effective.

This library provides an alternative to that, with ready to use filters that can be customised and integrated into your application quickly. They can be applied to almost any data source from iOS or elsewhere, and have been designed to be easy to use for someone with little or no signal processing experience. Key features include:

* A consistent, easy to use interface and simple data model
* “Drag and drop” functionality. Each filter can operate as a standalone class. No project imports or external dependencies required.
* The latest Swift 3 syntax.
* Concurrent calculations where necessary. 

# Basic Code Usage

There are two options here:

* Take the filter algorithm and use it as a standalone object with your existing project code. Best for users with signal processing knowledge or projects with their own sensor data handling set up.

* Use the data source and filter manager classes to completely handle sensor data processing, allowing raw and processed data to be accessed with a simple notification observer. - Best for new users/projects.

## Option 1: Standalone Filter

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

## Option 2: Data Source and Filter Manager

Initalise the data source manager:

    let dcm = dataSourceManage(sourceId: "John's iPhone")


Disable uneeded data sources, start up the rest: 

    dcm.modifyDataSources(accel:true,gyro:false,mag:false)
    dcm.initaliseDatasources()
    
Start filters:
    
    FilterManager.sharedInstance.addFilter(name: Algorithm.HighPass)
    FilterManager.sharedInstance.addFilter(name: Algorithm.BoundedAverage)

In the class to receive data, register observers for notifications:

For raw data:

    NotificationCenter.default.addObserver(self, 
        selector: #selector(myClass.newRawData), 
        name: Notification.Name("newRawData"), 
        object: nil)

For processed data:

    NotificationCenter.default.addObserver(self, 
        selector: #selector(myClass.newProcessedData),
        name: Notification.Name("newProcessedData"), 
        object: nil)

Where `myClass.newProcessedData` and `myClass.newRawData` are Objective-C functions that will be called with when a notification of new data is posted. They must accept a single `notification` argument. For example:

    @objc func newRawData(notification: NSNotification){
        let incomingData = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = incomingData["data"]
    }
    

## See the Wiki for more information on how to use this repo 
