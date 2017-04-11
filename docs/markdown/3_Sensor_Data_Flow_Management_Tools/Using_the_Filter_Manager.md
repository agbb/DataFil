The `filterManager` class provides a convenient way to manage the flow of sensor data through your application, particularly if using more than one filter simultaneously. It allows for filters to be connected to each other, and for data to be sent from the sensor source by notification. The addition of the filter manager to your project allows raw data to be directed into and processed data out of the filters with minimal modification to your existing code. To apply a filter using `filterManager`:

1.	`filterManager` is a singleton, so once the singleton is initialised it can be referred to globally. 
2.	Data can be directed at the filterManager by passing it in a notification with the following format. Initialising the filterManager will cause it to observe for this notification. Using the `dataSourceManager` class will direct sensor data at the class automatically using this system.
	1. `name:”newRawData”`
	1. `userInfo: [“data”:accelPoint]`
3.	To enable a filter, simply pass the name of the filter as described in the details below to the function `addNewFilter`, using the `Algorithm` enum. This can be done multiple times to add as many filters as required.
4.	This will cause the filter manager to post notifications with the processed data from this filter with a name `newProcessedData`.

The workflow above describes the initial setup of the manager. The complete set of functions is described in the documentation for this class below. While `filterManager` can make using the included algorithms easier, it is optional. All filters will function without it. To see an example of how the `filterManager` can be linked between your data sources and sinks, see the showcase app code. 

# Example Set Up 

Below is an example set up of the filterManager. To set up three filters, in order, we would execute:

    let filMan = filterManager.sharedInstance()
    filMan.addNewFilter(Algorithm.HighPass)
    filMan.addNewFilter(Algorithm.LowPass)
    filMan.addNewFilter(Algorithm.BoundedAverage)

To remove a filter and replace it with another, we would execute:

	filMan.removeFilter(Algorithm.BoundedAverage)
	filMan.addNewFilter(Algorithm.SavitzkyGolay)

To the other parts of the system the data flow remains unchanged. The data source and sink are unaware of this change to the system, effectively maintaining separation between our model, controller and view layers.  

# Variable Summary

| Name and Type                                  	| Description                                                                                                                                                                                                           	|
|------------------------------------------------	|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| `SharedInstance:FilterManager` (static constant) 	| Singleton variable for the class                                                                                                                                                                                      	|
| `activeFilters:[Filter]`                        	| Array of objects that implement the `Filter` protocol, that raw or partially processed data will be passed to. The filter manager expects these objects to eventually return an `accelPoint` and is listening for this. 	|

# Function Summary

### addNewFilter

`func addNewFiler(AlgorithmToAdd: Algorithm)`

This function is used to activate a new filter. The `Algorithm` enum is used to identify the filter to activate. When a filter is active, the `newProcessedData` notification will contain the convoluted output of the raw data and active filters. 

### newRawData

` @objc func newRawData(notification: NSNotification)`

Function nominated by the selector of the observer for new raw data from any source. Expects data to be passed in `userData` as:
    notification.userInfo as! Dictionary<String,accelPoint>
This function will only ever be called in response to a notification from an observed data source. To enable this, it must be exposed to objective-C, through the `@objc` annotation. When called, the function will pass the data into the chain of filters. 
If no filters are present, it will pass the raw data directly to the output.

### removeFilter

`func removeFilter(name: Algorithm)`

Function will deactivate the filter with the given name, if active. This will cause the data flow to bypass this filter, and either go to the next in the chain or the output.

### setFilterParamater

`func setFilterParameter(filterName: Algorithm, parameterName: String, parameterValue: Double)`

If active, this function will find the named filter and set the named parameter to the described value. This can be executed at any time. All filters will accept new parameters and update accordingly at any point. A filter may complain if an invalid parameter is passed in, however it is important to check the values being passed in fall within acceptable range. For more information check the specification of the filter in question.

### receiveData

`func receiveData(data: [accelPoint], id:Int)`

This function is called by active filters when they have new data to pass on. This can happen at any point. If there is processed data available to be passed to the data sink, a notification with the name `newProcessedData` will be made, with the new data points in the `userData` of the notification. This will have the format:
    `notification.userInfo as! Dictionary<String,accelPoint>`
Note that the amount of new points can be any non-zero value, and that every call to receive data may not result in a notification for new data. To collect processed data, your application should observe these notifications.