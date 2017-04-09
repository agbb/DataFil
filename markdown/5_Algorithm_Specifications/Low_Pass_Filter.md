# Introduction, Usage and Behaviour
This filter is conceptually the opposite of the high pass filter. It allows low frequency signals to pass through, while removing and smoothing out the high frequency ones. This makes it useful for removing noise from a signal. This filter is generic, and uses a coefficients generation algorithm to create a transfer function based on the parameters passed in, using a mathematical recipe. This means the filter is capable of behaving as several kinds of filter:

**Butterworth**

Designed to have a completely flat frequency response in the accepted range. This means that it treats all signals in the accepted range exactly the same.(Unicorn Trading Company, n.d.) 

It is prone to overshooting however. This means that the processed signal can temporarily exceed the amplitude of the raw signal if it changes quickly, this can be seen in the image below.(Butterworth S, 1930)

![Butterworth Overshoot](https://github.com/ozliftoff/Accelerometer-Graph/blob/master/images/butterworth.jpg?raw=true)

**Critically Damped**

A critically damped filter is designed to remove the overshooting effect seen in the Butterworth filter. The compromise however, is that a delay is introduced on the processed data when a rapid change in the raw data occurs. In the image below we can see that the overshoot is removed but the ascending and descending leg of the filter lag behind the raw data considerably. 

![Critically Damped Filter](https://github.com/ozliftoff/Accelerometer-Graph/blob/master/images/critdamped.jpg?raw=true)

**Bessel**

This filter interferes the least with the frequencies in the accepted frequency range, and will not overshoot. It is a compromise between the significant suppression of the critically damped filter and the more active Butterworth filter.  
The number of passes can be varied from 1 to 3, allowing the filter to be cascaded. Cascading filters can intensify their behaviour. For example, cascading the Butterworth filter will significantly increase the amount of overshoot. Cascading the critically damped filter will not cause it to overshoot. It will maintain the critical damping property. 
Overall, this filter is considerably more complex, particularly for the coefficients generation section of the algorithm, although this can be run only once. It does however offer a considerable amount of flexibility. Note that when the filter is started, the output signal will briefly drop to 0. This is normal and is part of the filter’s start-up routine. To avoid issues with data, start the filter before it is required to process data to ensure that it is ready. 

Complexity:

* Coefficient Calculation: O(1)
* Filter application: O(n) where number `n` = of passes on filter.

Memory load: 

* Coefficient Calculation:  O(1)
* Filter application: O(1) - Changing the number of passes does not change the memory usage of the filter.

# Parameters

| Name and Type            | Description                                                                                                                                                                                                                                                                                                                                                                                     |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `n:Double`  Range: 1...3   | Defines the number of passes of the filter. Increasing will cause the filter to cascade.                                                                                                                                                                                                                                                                                                        |
| `p:Double`  Range: 0.2...5 | Polynomial coefficient partially defining the transfer function of the filter. A lower p makes the filter more responsive, decreasing the smoothing effect of the filter, but also reduces lag in sudden changes. Decreasing below 1 will cause resonating amplification. If an order larger than 1 is used simultaneously it will occur increasing amounts indefinitely until overflow occurs. |
| `g:Double`  0.2...5        | Gain constant of the filter, forming part of the transfer function, defines the values that make the transfer function return 1 when passed 0. A larger G will reduce lag, but may lead to overshoot. A value of G below 1 for any value of P above 1 will result in a critically damped filter.                                                                                                | 

## Suggested Parameter Setup

| Filter Name       | n   | p   | g |
|-------------------|-----|-----|---|
| Butterworth       | 1   | 1.4 | 1 |
| Critically Damped | 1…3 | 2   | 1 |
| Bessel            | 1   | 3   | 3 |
| Linkwitz-Riley*   | 2   | 1.4 | 1 |

The mathematics and parameter set up for this filter are described [Here](http://unicorn.us.com/trading/allpolefilters.html).

[More information on Linkwitz-Riley filter](http://www.rane.com/pdf/ranenotes/Linkwitz_Riley_Crossovers_Primer.pdf)

# Testing 

Tests for this filter can be found in the `advancedLowPassTests.swift` file.