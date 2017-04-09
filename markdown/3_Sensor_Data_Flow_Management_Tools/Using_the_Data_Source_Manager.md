The `dataSourceManager` provides a tool to manage the sensor capabilities of the device. When enabled, it will create `accelPoint` objects that contain all the available sensor data, numbered sequentially. It can be instantiated on either an iOS or Watch OS device, and when running will post notifications under the name `newRawData`, that can be observed for globally that contain the latest `accelPoint` object. The `filterManager` class is set up by default to observe for these notifications for data to process.
To change sensor sample rate, a notification of the following format can be posted from anywhere in the application, where `sampleRate` is the double value of the desired rate:

    NotificationCenter.default.post(
        name: Notification.Name("newDatasourceSettings"), 
        object: nil, 
        userInfo:["sampleRate":sampleRate]
    )

The function to extract the `accelPoint` would then be as follows:

    @objc func newRawData(notification: NSNotification){
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]
    }


# Function Summary

### Initialiser

`init(sourceId: String)`

The source ID will be printed alongside any debugging statements to identify the source of the message, to ease development when working with remote devices.

### InitaliseDataSources

`func initaliseDatasources()`

When called, the `dataSourceManager` will attempt to startup all available sensors on the device. When ready, it will begin posting this data as `accelPoint` objects, in notifications under the name `newRawData`. As such, this data could be observed for using the following code:

    NotificationCenter.default.addObserver(self, 
       selector: #selector(FilterManager.newRawData), 
       name: Notification.Name("newRawData"), 
       object: nil)

### deinitDataSources

`func deinitDatasources()`

When called, the `dataSourceManager` will stop posting notifications with new raw data and will stop requesting sensor updates from the system. Should be used when data is no longer required to conserve power.

### modifyDataSources

`func modifyDataSources(accel:Bool,gyro:Bool,mag:Bool)`

Used to choose the active sensors. Unneeded sensors should be disabled using this method to conserve power. Placeholder 0 values will be used in the disabled sensor fields of posted `accelPoints`