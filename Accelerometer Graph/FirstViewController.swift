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
    var customAxisState = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.newRawData), name: Notification.Name("newRawData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.newProcessedData), name: Notification.Name("newProcessedData"), object: nil)
        
        self.TopLineChartView.delegate = self
        self.TopLineChartView.backgroundColor = #colorLiteral(red: 0.2940818071, green: 0.2941382527, blue: 0.2940782309, alpha: 1)
        self.TopLineChartView.noDataText = "No Data"
        
        self.BottomLineChartView.delegate = self
        self.BottomLineChartView.backgroundColor = #colorLiteral(red: 0.2940818071, green: 0.2941382527, blue: 0.2940782309, alpha: 1)
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
            
            let yAxisBottom = BottomLineChartView.getAxis(YAxis.AxisDependency.left)
            let yAxisTop = TopLineChartView.getAxis(YAxis.AxisDependency.left)

            if Double((BottomLineChartView.lineData?.yMax)!) >= Double((TopLineChartView.lineData?.yMax)!){
                //Bottom chart is higher, Make top chart max slave
                
                yAxisTop.axisMaximum = Double(yAxisBottom.axisMaximum)
                yAxisBottom.resetCustomAxisMax()
                
            }else{
                //Top chart is higher, make bottom chart max slave
                yAxisBottom.axisMaximum = Double(yAxisTop.axisMaximum)
                yAxisTop.resetCustomAxisMax()
            }
            if Double((BottomLineChartView.lineData?.yMin)!) <= Double((TopLineChartView.lineData?.yMin)!){
                //Bottom chart is lower, Make top chart min slave
                
                 yAxisTop.axisMinimum = Double(yAxisBottom.axisMinimum)
                 yAxisBottom.resetCustomAxisMin()
                
            }else{
                //Top chart is lower, Make bottom chart min slave
                yAxisBottom.axisMinimum = Double(yAxisTop.axisMinimum)
                yAxisTop.resetCustomAxisMin()
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
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "")
        set1.setColor(#colorLiteral(red: 0.2726118863, green: 0.6989091039, blue: 0.6175016761, alpha: 1))
        
        self.TopLineChartView.legend.enabled = false
        TopLineChartView.dragEnabled = false
        self.TopLineChartView.data = configureDataSet(set: set1)
        
    }
    
    func configureDataSet(set: LineChartDataSet)->LineChartData{
        set.axisDependency = .left
        set.lineWidth = 1.0
        set.fillColor = UIColor.blue
        set.highlightColor = UIColor.white
        set.drawCirclesEnabled = false
        set.drawValuesEnabled = false
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        return  data
    }
    
    func setBottomChartData(values: [Double]){


        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< values.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "")
        set1.setColor(#colorLiteral(red: 0.8692195415, green: 0.3558411002, blue: 0.2854923606, alpha: 1))

        self.BottomLineChartView.legend.enabled = false
        BottomLineChartView.dragEnabled = false
        self.BottomLineChartView.data = configureDataSet(set: set1)
    }
    
}

