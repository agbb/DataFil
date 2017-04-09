# Introduction, Usage and Behaviour 
This filter functions by taking a moving average of a previous values and determining if it falls within a set of parameterised bounds. If it does, it outputs a value in the middle of those bounds. If it does not, the new middle value is set to the raw data value, and the bounds recreated. This results in a filter that outputs a steady signal until a threshold is met, at which point the output jumps instantaneously until the in-bounds property is recovered. 
This filter would be well suited to situations where:

* The signal to noise ratio is fixed. The bounds of the filter can be set just larger than the noise level, resulting in a very clean, steady signal.
* The input data is a binary signal combined with some amount of noise. This filter is effective at recovering the original binary signal.
* Like the binary data, the output signal will fall into categories. For example magnetometer data to the directions on a compass rose. The output will be a steady signal in one of the points, and will quickly and precisely jump to the next point when the signal dictates. 

Complexity:

* Filter application: O(n) where `n` = number of points to consider in average. 

Memory load: 

* Filter application: O(n) where `n` = number of points to consider in average.
While the algorithm does not run in constant time, the number of historical points to consider is likely small. The algorithm can run with 0 previous values considered.  


# Parameters

| Name and Type                      | Description                                                                             |
|------------------------------------|-----------------------------------------------------------------------------------------|
| `upperBound:Double`  Range: 0...8    | The upper bound beyond which the signal centre is reset and the bounds shift upwards.   |
| `lowerBound:Double`  Range: 0...8    | The lower bound beyond which the signal centre is reset and the bounds shift downwards. |
| `pointsAverage:Double`  Range: 0...n | The number of points to consider in the moving average. Determines complexity.          |

![Bounded Average Application](https://github.com/ozliftoff/Accelerometer-Graph/blob/master/images/boundedAvg.jpg?raw=true)

The figures above show that the bounds size must be carefully matched to the expected accelerations in the application. If there are too small, the data is noisy and has many artefacts. If the bounds are too large, changes in the data are lost, and the bounds can settle at an inaccurate value.

# Testing

Tests for this filter can be found in the `boundedAverageTests.swift` file.

	