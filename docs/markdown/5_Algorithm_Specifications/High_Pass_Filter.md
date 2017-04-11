# Introduction, Usage and Behaviour 

The high pass filter is the simplest of the filtering algorithms included in the library, but is extremely useful. The filter functions by allowing high frequency signals to pass, but removing low frequency ones. This makes it useful for isolating and removing bias in a signal such as gravity. It does not however remove high frequency noise that is often characteristic of MEMS sensors.

Complexity:

* Coefficient Calculation:  O(1)
* Filter application: O(1)

Memory load: 

* Coefficient Calculation:  O(1)
* Filter application: O(1)

The complexity and memory requirements of this filter are constant and trivial. At any one time the algorithm keeps track of the previous raw and processed value.

# Parameters

| Name and Type | Description |
|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| CutPoint:Double Range: 0...10 | Frequency at which the signal is attenuated. The lower this value, the lower the frequency of a signal needs to be to be attenuated. This results in a less active filter that takes longer to return to zero after displacement. |
| Freq:Double | The frequency of the sampling source. This is used in the coefficient calculation. |                                                                                                                                           	|

![High Pass Filter Application](https://github.com/ozliftoff/Accelerometer-Graph/blob/master/images/highPass.jpg?raw=true)


It can be seen that when a small cut-off frequency is used, the time taken for the filter to bring the signal back to 0. At very high values we can see that this is almost instantaneous. When working with this filter it is important to strike a balance between responsiveness and over activity cutting out useful data.

# Testing 

Tests for this filter can be found in the `highPassTests.swift` file.

