# Introduction, Usage and Behaviour

This is yet another style of filter that is better suited to batch processing of data. This means that if for example you are recording data and not using it in real time, this filter can be used to yield an extremely clean signal, by passing in all the data at once. For the purposes of the live demo, the data points are batched together in a buffer and processed in groups of size 10 to 1000. The larger the batch size, the longer the lag, but the more consistent the output data. 
This filter is an implementation of the total variation denoising method proposed in “Laurent Condat. A Direct Algorithm for 1D Total Variation Denoising. 2013.” Broadly, the filter operates by creating a value that it tries to preserve for as long as possible, as it moves through the data. For as long as it can do this, the generated value is set as the output at that point. If it cannot preserve, it backtracks to a point where a new value can be generated, set it as the new point to preserve and continues. (Condat, 2013). More information on the detailed operation can be found in the paper mentioned above. The output of this filter is a flat value, with instant jumps to new values, similar in style to the output of the bounded average filter.
The filter only considers values looking forward from its current position in the dataset, meaning that memory usage is minimal. It also means however that the output is sensitive to the size of the input dataset. Therefore, the maximum allowable dataset size should be passed in. This filter can be combined with low pass filter to great effect. The clean output of the total variation filter is combined with the smoothing effect of the low pass algorithm to create a clean, smooth signal that responds quickly and decisively to change, making the combination ideal for applications such as games where specific movements are triggered by accelerometer events. 

Complexity:
* Filter application: O(n^2) where `n` = number of points in the input dataset.
Memory load: 
* Coefficient Calculation: O(n^2) where `n` = number of points in the input dataset.

Information on the complexity of this algorithm is provided in the paper discussed above. (Condat, 2013)
When using this filter in the showcase app, the graph may appear to freeze. This is normal behaviour, and the graph will update with new values as they are batch processed. This effect can be reduced by selecting a smaller batch size. The live raw data can be viewed by tapping settings and then unchecking Single Raw & Filtered Graph. The bottom graph will update in jumps as new processed data becomes available.

# Parameters 

| Name and Type                   | Description                                                                                                                                                                                                                                                                                                                                                                                        |
|---------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `lambda:Double`  Range: 0.01...1  | Defines the sensitivity of the filter to changes in value. The larger the lambda value, the larger change in acceleration is required to trigger an update of the output value. It also causes instantaneous jumps to be larger when they occur. This should be tested to a value that is above the level of noise in your data but below the magnitude of changes that are considered meaningful. |
| `bufferSize:Double`  Range: 1...n | Defines the size of the batch to be processed at once. When using the filter for real-time applications this will define the delay. For efficiency and output data consistency, the largest acceptable value should be used.                                                                                                                                                                       |

![Total Variation Dnoising](https://github.com/ozliftoff/Accelerometer-Graph/blob/master/images/tvd.jpg?raw=true)

The sample graphs above show some of the characteristic behaviour of the total variation denoising filter. The first displays clearly how the overall movement in the data is isolated by removing extreme peaks and troughs. It also shows the flat tops at the maxima and minima of the data, characteristic of this algorithm. The middle is included to clearly display the way in which the filter behaves with sudden changes. It can be seen that a single instantaneous jump was made from the old signal value to the new. The effect of selecting a smaller batch size can be seen in the last image. Compared to the first, the processed data more closely resembles the raw data, and the flat tops at maxima and minima are smaller and less clear. 


# Testing 
Tests for this filter can be found in the `totalVarTests.swift` file
