# DataFil - A Complete Signal Processing Toolkit for iOS

A convenient and reliable set of signal processing tools for developers to integrate into their project to better utilise the sensors on an iPhone. 

Creating a filter that has the right characteristics can be an extremely time consuming task, and often requires knowledge of signal processing.

This library provides an alternative to that, with ready to use filters that can be customised and integrated into your application quickly and easily. 

Key features include:

* A consistent, easy to use interface and simple data model
* “Drag and drop” functionality. Each filter can operate as a standalone class. No project imports or external dependencies required.
* The latest Swift 3 syntax.
* Concurrent calculations where necessary. 

## Basic Code Usage

There are two options here:

* Take the filter algorithm and use it as a standalone object with your existing project code. Best for users with signal processing knowledge or projects with their own sensor data handling set up.

* Use the data source and filter manager classes to completely handle sensor data processing, allowing raw and processed data to be accessed with a simple notification observer. - Best for new users/projects.

### Option 1: Standalone Filter

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

### Option 2: Data Source and Filter Manager

Initalise the data source manager:

    let dcm = dataSourceManager(sourceId: "John's iPhone")


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
 
## Apple Watch Data Streaming

The toolkit also provides the complete set of code requried to stream sensor data from an Apple Watch to an Iphone. The filters are all compatible with the Apple Watch, and all of the code in the `GlobalModel` group is designed to run on either platform.

### Basic Usage

To stream data from the Apple Watch to a paried iPhone:

Both devices must have a copy of the `GlobalModel` group available to them. Ensure this by checking the Targets of the group in the attributes inspector. 

**On the Apple Watch:**

Start the data sources:

    let dcm = dataSourceManager(sourceId: "John's Apple Watch")
    
Disable uneeded data sources, start up the rest: 

    dcm.modifyDataSources(accel:true,gyro:false,mag:false)
    dcm.initaliseDatasources()
    
Begin pushing sensor data to the iPhone: 

    RemoteDataInterface.sharedInstance.publishOutgoingData()
    
 **On the iPhone:** 
 
 Start listening for incoming data:
 
     remoteCommunicator.sharedInstance.start(deviceId: "device")
 
 In the class to receive the remote data:
 
     NotificationCenter.default.addObserver(self, selector: #selector(myClass.newRemoteData), name: Notification.Name("newRemoteData"), object: nil)
     
Where `myClass.newRemoteData` is an Objective-C function that will be called with when a notification of new data is posted. It must accept a single `notification` argument. 

### Other Features

The Apple Watch communication shown here is extremely powerful, and allows for to way sending of key value messages between the devices, as well as the observation of incoming keyed messages from anywhere in the application. For more informaiton, see the Remote Communicator page in the wiki. 

# Showcase App and Example Code

Included in this project is a showcase app which can be used to experiment with the filters to find the right one for your needs. It also serves as example code of all the features detailed above. 

### Instalation

Requires Xcode 8.3 or later and a ** real ** iPhone or iPad running iOS 10 or later. Simply open the DataFil project in Xcode, sign it and sideload it onto your device. 

### Features

* Realtime sensor data display
* Interactive filters
* Data recording and exporting as CSV or JSON
* Apple Watch sensor data streaming for visualisation or recording.

A full user guide on all of the features of the showcase app can be found in the `How to Use the Showcase App` and 

`Using an Apple Watch with the Showcase App` pages of the Wiki.
## See the Wiki for more information on how to use this repo 
