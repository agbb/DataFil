//
//  FirstViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 07/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import UIKit
import Charts

//struct notificationManager{
 //   static var nc = NotificationCenter.default
 //   static let newRawDataNotification = Notification.Name("newRawData")
//}

class FirstViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var BottomLineChartView: LineChartView!
    @IBOutlet weak var TopLineChartView: LineChartView!
    var axis = "x"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.newRawData), name: Notification.Name("newRawData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.newProcessedData), name: Notification.Name("newProcessedData"), object: nil)
        
        self.TopLineChartView.delegate = self
        self.TopLineChartView.backgroundColor = UIColor.lightGray
        self.TopLineChartView.noDataText = "No Data"
        
        self.BottomLineChartView.delegate = self
        self.BottomLineChartView.backgroundColor = UIColor.lightGray
        self.BottomLineChartView.noDataText = "No Data"
       
        setTopChartData(values: [0])
        setBottomChartData(values: [0])
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func newRawData(notification: NSNotification){
        
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]

        let newEntry = ChartDataEntry(x: Double((accelData?.count)!), y: (accelData?.x)!)
        TopLineChartView.data?.addEntry(newEntry, dataSetIndex: 0)
        if((accelData?.count)! > 300){
            TopLineChartView.data?.removeEntry(xValue: 0, dataSetIndex: 0)
        }
        TopLineChartView.notifyDataSetChanged()
        TopLineChartView.data?.notifyDataChanged()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // your code here
            self.TopLineChartView.setNeedsDisplay()
        }
        
    }
    
    func newProcessedData(notification: NSNotification){
        
        let data = notification.userInfo as! Dictionary<String,[accelPoint]>
        let accelDataArray = data["data"]
        
        for accelData in accelDataArray!{
            let newEntry = ChartDataEntry(x: Double(accelData.count), y: accelData.x)
            BottomLineChartView.data?.addEntry(newEntry, dataSetIndex: 0)
            if(accelData.count > 300){
                BottomLineChartView.data?.removeEntry(xValue: 0, dataSetIndex: 0)
            }
            BottomLineChartView.notifyDataSetChanged()
            BottomLineChartView.data?.notifyDataChanged()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // your code here
                self.BottomLineChartView.setNeedsDisplay()
            }
        }
    }
    
    func setTopChartData(values: [Double]){
      
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< values.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Raw Data")
        set1.axisDependency = .left
        TopLineChartView.dragEnabled = false
        set1.setColor(UIColor.red.withAlphaComponent(0.5))
        set1.lineWidth = 1.0
        set1.drawCirclesEnabled = false
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        
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
        set1.lineWidth = 1.0
        set1.fillColor = UIColor.blue
        set1.highlightColor = UIColor.white
        set1.drawCirclesEnabled = false
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(UIColor.white)
        
        self.BottomLineChartView.data = data
    }
    
}

