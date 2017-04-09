# Introduction, Usage and Behaviour

This filter is different from the previous three, in that it is non-casual. This means that it must consider both future and previous points when calculating the smoothing of the current point. This has advantages and drawbacks, the most obvious of which is that it introduces a delay proportional to the number of future points being considered.  The main advantage however is a more nuanced smoothing function that helps to maintain the amplitude and frequency of the input data, but is very effective at increasing the signal-to-noise ratio. 
The filter functions through the use of convolution. Using linear algebra to apply a curve fitting of a second or forth degree polynomial to the data. The coefficients are calculated beforehand, by creating an imaginary curve with length n+1, where n is the number of the points to the left and right being considered. In this imaginary list, all points are set to zero apart from the centre, which is set to 1. The values of the polynomial curve that are created about this point become the coefficients that are applied to the raw data values at runtime.
![Savitzky-Golay Application](https://github.com/ozliftoff/Accelerometer-Graph/blob/master/images/savgol1.jpg?raw=true)

The calculated coefficients are applied through the use a of a simple weighted moving average to the left and right of the point in consideration. This makes the filter computationally light at runtime.

Complexity:

* Coefficient Calculation: O((nl+nr)^m)  where `nl` = leftScan and `nr` = rightScan and `m` = polynomial order (2 or 4)
* Filter application per point: O(nl+nr) where `nl` = leftScan and `nr` = rightScan

Memory load: 

* Coefficient Calculation: O((nl+nr)^m)  where `nl` = leftScan and `nr` = rightScan and `m` = polynomial order (2 or 4)
* Filter application per point: O(nl+nr) where `nl` = leftScan and `nr` = rightScan

# Parameters

| Name and Type                                       | Description                                                                                                                                                                                                                                                                                                                                           |
|-----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `leftScan:Double`  Range: 1...n                       | Defines the number of future,points that should be considered when calculating the current point. The larger this value, the larger the delay. A large difference between the left and right range can lead to anomalous behaviour. A forward scan value slightly larger than a backward scan value can reduce under and overshoot on sudden changes. |
| `rightScan:Double`   Range: 1...n                     | Defines the number of historic points to be considered when calculating the current point. Does not affect delay. Does increase memory use. A higher value results in a smoother output.                                                                                                                                                              |
| `filterPolynomial:Double`  (rightScan+leftScan+1)...n | The order of the polynomial used to calculate the coefficients. A higher order polynomial filter will respond better to high amplitude changes. Note that this value must be larger than (nr+nl+1) or no filtering will be applied. An error will be displayed in the console.                                                                        |

![Savitzky-Golay Application](https://github.com/ozliftoff/Accelerometer-Graph/blob/master/images/savgol2.jpg?raw=true)

The above graphs are examples of a good and two bad configurations of this filter. The first above shows well how a properly calibrated filter will preserve the height and width of major movements in the data. The second displays anomalous changes on the descending and ascending leg of the major movement due to a low order being used with comparatively high numbers of points being considered. Lastly, the third shows a configuration where the polynomial is too low, and the number of points considered too high for the frequency of change present in the data. The height and width of the data is lost. 

# Testing

Tests for this filter can be found in the `savGolTests.swift` file
