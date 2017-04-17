An `accelPoint` object represents an instantaneous sensor reading, with X Y and Z values. Distinct points should be given unique IDs. This ID may be for example a sequence number or a timestamp of the reading. Initialisation using the default initialiser will set all values, including ID to 0. accelPoints are used as the data model input and output for the filter algorithms, and is designed to be similar in function to Apple’s implementation.

# Variable Summary

| Name and Type | Description                                         |
|---------------|-----------------------------------------------------|
| `xAccel:Double`        | Acceleration in the x axis in ms2                   |
| `yAccel:Double`        | Acceleration in the y axis in ms2                   |
| `zAccel:Double`        | Acceleration in the z axis in ms2                   |
| `xGyro:Double`         | Rotational velocity in x axis in rad/sec            |
| `yGyro:Double`         | Rotational velocity in y axis in rad/sec            |
| `zGyro:Double`         | Rotational velocity in z axis in rad/sec            |
| `xMag:Double`          | Magnetic field in x axis in militeslas              |
| `yMag:Double`          | Magnetic field in y axis in militeslas              |
| `zMagDouble`          | Magnetic field in z axis in militeslas              |
| `Count:Int`     | The identification number of the acceleration point 	|

# Function Summary

### get$Axis

`func getAccelAxis(axis: String) -> Double`

`func getGyroAxis(axis: String) -> Double`

`func getMagAxis(axis: String) -> Double`

Utility function used to allow data access to be configured by a string, in a similar fashion to the parameter stinging functionality provided in accelPoint. Allows for runtime changes to the axis of data that is being filtered or accessed.
