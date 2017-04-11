# Introduction
Each filter behaves differently, and is suited to different applications. To ease in the process of choosing the right filter for you, a showcase app is available that can be used to analyse and experiment with each filter to find the right configuration for your application. The app’s source code is available on GitHub, and it will be downloadable on the Apple App Store. 
# Key Features 
The data displayed in the graph is the real-time output of the iPhone’s accelerometer in the x-axis by default, with a series for raw and processed data. The source and axis of the data can be changed by tapping the Settings button. Here the scale can be modified and the graph can be split into two, with one for raw and processed data respectively.
Below is table of the available filters that can be applied to the data. Tapping on each one will reveal the configuration page for that filter. Here, the filter can be switched on and off, and the parameters modified. The changes to the filter settings are reflected on the graph in real time. Experiment with this to find a data output that works for your application. Some things to consider when choosing a filter and configuration:

* Is it more important that the amplitude or frequency of that acceleration be preserved?
* Do you want to remove noise from the data, or correct for bias caused by factors such as gravity?
* Is it more important to get fresh data or clean data? In other words, is the performance of the filter or quality of its output more 
* Does the data change slowly over time, or quickly in bursts?

Your answers to these questions should guide your choice, along with the observed be behaviour in the showcase app and information provided in this document. Each one of the above priorities lends itself to a different filter. 
The app allows the viewing and recording real-time data from the device’s sensors, which can be exported in JSON or CSV format. The format of the JSON and CSV export files can be seen below

### JSON Format

    {
        date: "yyyy-MM-dd HH:mm:ss '+'ZZZZ",
        filters: {
            filterName: {
                paramName: DoubleValue
            }
        }
        processed: [
            {
                ID:Int
                x:Int
                y:Int
                z:Int
            }
        ],
        raw: [
            {
                ID:Int
                x:Int
                y:Int
                z:Int
            }
        ]
    }

### CSV Format

    ID,rawX,rawY,rawZ,processedX,processedY,processedZ


Note that these patterns will be reproduced for every sensor active.

This data can be emailed as a .txt attachment. To use this feature, tap the Record tab on the bottom of the app. 
Previously recorded captures can be accessed by tapping the Saved Captures button at the bottom of the data capture page. Here a table of captures is displayed, ordered by date. The data in the filters section of the JSON export can be used to configure the parameters of the filter upon implementation. Note that it is possible to enable more than one filter at once, and the order in which they are applied to the data will influence the output. As such, the order of the filters in the JSON output reflects the true order.
For details on how to do this, see the Filter Interface section directly below.
To export, tap on the desired capture, which will cause an email to be composed with the selected data attached. They can be removed from storage by swiping right and tapping delete. 

