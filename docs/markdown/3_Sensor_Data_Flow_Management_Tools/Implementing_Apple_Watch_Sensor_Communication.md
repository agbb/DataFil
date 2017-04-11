The communication of data to and from the Apple Watch is handled using the following classes, found in the globalModel group:

* `RemoteDataInterface`
* `Serialiser`
* `RemoteCommunicator`

The stack is symmetrical, meaning that the same code can be used to start a session from both devices. In the following sections, each class in the stack is described. 

# Remote Communicator

The `RemoteCommunicator` class is the lowest level in this process, used to manage the communication session with the remote device, and is independent of any other part of the application, meaning it can be used to send any arbitrary message to and from the watch. Messages are sent as a key value pair, and observers can subscribe to be notified when a message with a matching key arrives. This allows messages of different types to be sent and received to specific parts of the application without the need to determine if a specific message is relevant in the main logic of the application. Each observing communicator can assume that if it is notified of a message that it was intended for them. 

The class is instantiated with a `deviceId`, for debugging purposes, allowing the source devices of console messages to be traced. It also contains several methods for checking if the remote partner is connected and reachable. 

## Function Summary

### Start

`func start(deviceId: String)`

Attempts to start a session with the remote device. Should this not be possible an error message will be printed to the console. This method must be called before attempting communication.

### isSupported

`func isSupported() -> Bool`

Returns a Boolean detailing if Apple Watch communication is supported by the device.

### watchIsConnected

`func watchIsConnected() -> Bool`

Returns a Boolean detailing if an Apple Watch is connected and can be reached for communication.

### sendMessage

`func sendMessage(key: String, value: Any)`

Attempts to send a message with key and value passed into the function to the remote device. If this fails, a message will be printed to the console. On the remote device, any observer subscribed to messages with the matching key will be notified of the contents.

### addObserver

`func addObserver(key: String, update: @escaping (Any) -> Void)`

Adds a callback from an observing class that will be called when a message with a matching key arrives from the remote device. It must accept any object as this is what can be passed into the `sendMessage` function on the remote partner.

# Remote Data Interface

Next in the stack is the logic specific to sending and receiving sensor data. This is the responsibility of the `remoteDataInterface`. It can be used to send outgoing sensor data to the remote partner, by observing for new local data though the same observer system used for all consumers. The `remoteDataInterface` can observe to the `remoteCommunicator` class to listen for new incoming remote data, which will arrive under a specific key. When listening, it will notify other consumers of sensor data using the same notification format as local sensor data notifications, meaning that any consumer of local data can be trivially switched to listen for remote data. This symmetry of the communication hierarchy and uniform processing of remote and local data means that if desired, the watch could listen for sensor data from the iPhone, or even another watch. There is no pre-defined rigid data flow. 

Note that remoteDataInterface is a singleton.

## Function Summary

### publishOutgoingData

`func publishOutgoingData()`

When called the class will begin attempting to send new raw data published by the `dataSourceManager` to the remote device. Can be used to send raw data from the Apple Watch to the iPhone.

### subscribeIncomingData

`func subscribeIncomingData()`

Will cause the device to start listening to messages sent from the `publishOutgoingData` function on the remote device. When received, the data will be published globally under a notification named `newRemoteData`. 

# Serialiser

It is important to note that it is not possible simply to send `accelPoint` objects to a remote device. The communication protocol defined by Apple can only accept primitive objects such as Strings, Doubles and Integers. For this reason, the `remoteDataInterface` will serialise each `accelPoint`, using the `Serialiser` class before sending. When receiving, it will de-serialise the incoming primitive back into an `accelPoint` object before notifying consumers of this data. This process is transparent to the sender and receiver of the sensor data, and part of the hierarchical design of the communication. These functions do not need to be called directly, they are used as required by the `remoteDataInterface` for sending and receiving.

## Function Summary

### serialise

`serialise(input: accelPoint) -> String`

Will convert a valid `accelPoint` object into a `String` for sending. Reversed with `deserialise`.

### deserialise

`deserialise(input: String) -> accelPoint`

Will convert a valid `String` into an `accelPoint` object. Reverse of `serialise` function.




