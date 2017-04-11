Every filter implements this protocol, and as such it should be included in any project utilising them. It defines a standard interface that each filter will conform to. Below is a list of function definitions and their description.

# Variable Summary

| Name and Type                      | Description                                                                       |
|------------------------------------|-----------------------------------------------------------------------------------|
| `filterName:Algorithm`                 | Get only. The full English name of the filter                                     |
| `Params: [String:Double]`            | Get only. A dictionary with parameter name and values as key value pairs.         |
| `Observers:[(_:[accelPoint])->Void]` | Get only. A list of callbacks that should be executed when new data is available. |

# Function Summary

### addDataPoint

`func addDataPoint(dataPoint:accelPoint) -> Void`

Void function used to add a data point to the filter to be processed. Filter expects a unique ID, and all values to be set. 

### addObserver

`func addSubscriberCallback(update: @escaping (_: [accelPoint])-> Void)`

Void function used to add a callback closure to the filter as an observer. The added observer will be executed when new processed data is available. This call will always be made on the main thread, but may be made at any time after adding a data point. It may contain any number of `accelPoint`s as an array, that contain the same ID as their raw counterpart but the processed values for x, y, z. The returned `accelPoint` object will not be same as the last one passed in, and may have a different ID, as some filters buffer values. 
The closure has the `@escaping` attribute as it will be executed after the `addSubscriberCallback` function has returned. It must accept an argument named `data:[accelPoint]` and return `void`.

### notifySubscribers

`func notifySubscribers(data: [accelPoint])`

Function called by the algorithm in the filter class to signal that new data is ready. The function should be implemented to execute all closures stored in the observers property of the filter. 
It will pass through a non-empty array of `accelPoint` objects into the closures. Each `accelPoint` will contain the filtered data with the matching ID of the raw data counterpart.

### setParameter

`func setParameter(parameterName:String, parameterValue:Double) -> Void`

Used to modify the parameters of the filtering algorithm. This can be done at any time during the filter’s lifetime to override the default values. A list of the parameters each filter contains can be found their section of this document.