# Introduction
This section describes in detail how to interact with the filters in your application. Every filter included has the same interface, as defined by the FilterProtocol. The filters should only be interacted with through this interface, as while they may have other methods publicly visible for testing purposes, these methods will not configure the filter state correctly, and may lead to poor data or crashes. 

# `Algorithm` Enumeration

Each filter algorithm is identified through the use of the `Algorithm` enum. It contains the following values:

* `HighPass`
* `LowPass`
* `BoundedAverage`
* `SavitzkyGolay`
* `TotalVariation`

Functions described elsewhere, such as `addNewFilter` require the use of this enum to identify the filter to activate, and should therefore be included in the project.

`Algorithm.x.description` will return an English full name of the filter. 

 
# Setup and Use
Every filter depends on 3 key items, which should be included in your project: 
* `accelPoint` class
* `Filter` protocol
* `Algorithm` enum

Some filters may have additional dependencies that must be imported alongside the file. These will be specified in the section of the documentation pertaining to that filter and the class itself. 
Once the required files have been imported into your project, the filter will be ready for use. The following workflow will then apply:
1. Create a new filter object, using the default initialiser. As each filter will have an internal state, it is important that a filter is only used for one data stream at a time. New objects should be created to filter data from multiple sources at once. 
1. Add a callback to the filter, using the `addSubscriberCallback` function.
1. Create an `accelPoint` object with the data to be filtered, and pass it into the filter object using the `addDataPoint` function
1. Registered observer callbacks will be called with new data when it is ready. 