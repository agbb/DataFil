//
//  FirstViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 07/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import UIKit
import Charts

struct notificationManager{
    static var nc = NotificationCenter.default
    static let newRawDataNotification = Notification.Name("newRawData")
}

class FirstViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var BottomLineChartView: LineChartView!
    @IBOutlet weak var TopLineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationManager.nc.addObserver(self, selector: #selector(FirstViewController.newRawData), name: notificationManager.newRawDataNotification, object: nil)
        self.TopLineChartView.delegate = self
        self.TopLineChartView.chartDescription?.text = "Tap node for details"
        self.TopLineChartView.backgroundColor = UIColor.lightGray
        self.TopLineChartView.noDataText = "No Data"
        
        self.BottomLineChartView.delegate = self
        self.BottomLineChartView.chartDescription?.text = "Tap node for details"
        self.BottomLineChartView.backgroundColor = UIColor.lightGray
        self.BottomLineChartView.noDataText = "No Data"
        
        setTopChartData(values: [1453.0,2352,5431,1442,5451,6486,1173,5678,9234,1345,9411,2212])
        setBottomChartData(values: [5641.0,2234,8763,4453,4548,6236,7321,3458,2139,399,1311,5612])
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func newRawData(notification: NSNotification){
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]
        print(accelData?.x)
    }
    
    func setTopChartData(values: [Double]){
      
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< values.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Raw Data")
        set1.axisDependency = .left
        set1.setColor(UIColor.red.withAlphaComponent(0.5))
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCirclesEnabled = true
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        
        self.TopLineChartView.data = data
    }
    
    func setBottomChartData(values: [Double]){


        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< values.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Filtered Data")
        set1.axisDependency = .left
        set1.setColor(UIColor.blue.withAlphaComponent(0.5))
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0
        set1.fillColor = UIColor.blue
        set1.highlightColor = UIColor.white
        set1.drawCirclesEnabled = true
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        
        self.BottomLineChartView.data = data
    }
    
}

