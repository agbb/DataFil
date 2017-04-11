//
//  MainViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 07/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit
import Charts

/*
 Class responsible for the display and management of graphics on the app. Utilises iOS Charts: https://github.com/danielgindi/Charts licence: MIT
 */
class MainViewController: UIViewController, ChartViewDelegate {

    
    
    @IBOutlet weak var BottomLineChartView: LineChartView!
    @IBOutlet weak var TopLineChartView: LineChartView!
    private var axis = "x"
    private var autoScale = true
    private var customAxisState = false
    private var singleView = true
    private var pointsCount = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.newRawData), name: Notification.Name("newRawData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.newProcessedData), name: Notification.Name("newProcessedData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newGraphSettings), name: Notification.Name("newGraphSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        self.TopLineChartView.delegate = self
        self.TopLineChartView.backgroundColor = #colorLiteral(red: 0.2940818071, green: 0.2941382527, blue: 0.2940782309, alpha: 1)
        self.TopLineChartView.xAxis.labelTextColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)
        self.TopLineChartView.leftAxis.labelTextColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)
        self.TopLineChartView.rightAxis.labelTextColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)
        self.TopLineChartView.noDataText = "No Data"
        self.TopLineChartView.chartDescription?.text = ""
        self.TopLineChartView.legend.textColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)
        
        self.BottomLineChartView.delegate = self
        self.BottomLineChartView.backgroundColor = #colorLiteral(red: 0.2940818071, green: 0.2941382527, blue: 0.2940782309, alpha: 1)
        self.BottomLineChartView.noDataText = "No Data"
        self.BottomLineChartView.chartDescription?.text = ""
        self.BottomLineChartView.xAxis.labelTextColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)
        self.BottomLineChartView.leftAxis.labelTextColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)
        self.BottomLineChartView.rightAxis.labelTextColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)
        self.BottomLineChartView.legend.textColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)

        
       setTopChartData(values: [0])
        
        if !singleView{
            
        }else{
            TopLineChartView.isHidden = true
            
                for const in self.view.constraints{
                    if const.identifier == "heightLimit"{
                        const.priority = 1
                    }else if const.identifier == "override"{
                        const.constant = 22
                        const.priority = 999
                    }
                }
            }
        setBottomChartData(values: [0])
        
    }


    

    func rotated(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            // Put your code which should be executed with a delay here
            if utilities.singleView == false {
                for const in self.view.constraints{
                    if const.identifier == "override"{
                        let height = (self.view.frame.height - 210)/2
                        const.constant = height
                    }
                }
                self.view.updateConstraints()
                self.view.layoutSubviews()
            }
        })
    }
    
    func newGraphSettings(notification:NSNotification){

        if notification.userInfo?["singleView"] as! Bool == false{
            utilities.singleView = false
            TopLineChartView.isHidden = false

           BottomLineChartView.data?.getDataSetByIndex(0).visible = false
            for const in self.view.constraints{
                if const.identifier == "heightLimit"{
                    const.priority = 999
                }else if const.identifier == "override"{
                    let height = (self.view.frame.height - 210)/2
                    const.constant = height
                    const.priority = 1
                }
            }
            singleView = false
            
        }else{

            utilities.singleView = true
            TopLineChartView.isHidden = true
            
            BottomLineChartView.data?.getDataSetByIndex(0).visible = true
            for const in self.view.constraints{
                if const.identifier == "heightLimit"{
                    const.priority = 1
                    
                }else if const.identifier == "override"{
                    const.constant = 22
                    const.priority = 999
                }
            }
            singleView = true
        }
        
        pointsCount = notification.userInfo?["pointsCount"] as! Int
 
        while((TopLineChartView.lineData?.dataSets[0].entryCount)! > pointsCount+1){
       
            _ = BottomLineChartView.data?.removeEntry(xValue: 0, dataSetIndex: 0)
            _ = BottomLineChartView.data?.removeEntry(xValue: 0, dataSetIndex: 1)
            _ = TopLineChartView.data?.removeEntry(xValue: 0, dataSetIndex: 0)
        }
        utilities.pointCount = pointsCount
        
        autoScale = notification.userInfo?["autoScale"] as! Bool
        if(!autoScale){
              //  TopLineChartView
        }
        self.view.updateConstraints()
        self.view.layoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func newRawData(notification: NSNotification){
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]

        let newEntry = ChartDataEntry(x: Double((accelData?.count)!), y: (accelData?.xAccel)!)
        
        
        TopLineChartView.data?.addEntry(newEntry, dataSetIndex: 0)
        BottomLineChartView.data?.addEntry(newEntry, dataSetIndex: 0)
        
        if((TopLineChartView.lineData?.dataSets[0].entryCount)! > pointsCount+1){
            
           _ =  TopLineChartView.data?.removeEntry(xValue: 0, dataSetIndex: 0)
            _ = BottomLineChartView.data?.removeEntry(xValue: 0, dataSetIndex: 0)
        }
        
        TopLineChartView.notifyDataSetChanged()
        TopLineChartView.data?.notifyDataChanged()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.TopLineChartView.setNeedsDisplay()
        }
        
        
    }
    
    func newProcessedData(notification: NSNotification){

        let data = notification.userInfo as! Dictionary<String,[accelPoint]>
        let accelDataArray = data["data"]
        
        for accelData in accelDataArray!{
            let newEntry = ChartDataEntry(x: Double(accelData.count), y: accelData.xAccel)
            
             BottomLineChartView.data?.addEntry(newEntry, dataSetIndex: 1)
            
            
            if((BottomLineChartView.lineData?.dataSets[1].entryCount)! > pointsCount+1){
                
                _ = BottomLineChartView.data?.removeEntry(xValue: 0, dataSetIndex: 1)
            }
            
            if singleView{
             
                
            }else{

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
        
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Raw X-Axis")
        set1.setColor(#colorLiteral(red: 0.8692195415, green: 0.3558411002, blue: 0.2854923606, alpha: 1))
        
        
        self.TopLineChartView.legend.enabled = false

        TopLineChartView.dragEnabled = false
        self.TopLineChartView.data = configureDataSet(sets: [set1])
        
    }
    
    func configureDataSet(sets: [LineChartDataSet])->LineChartData{
        
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        
        for set in sets{
            set.axisDependency = .left
            set.lineWidth = 1.0
            set.fillColor = UIColor.blue
            set.highlightColor = UIColor.white
            set.drawCirclesEnabled = false
            set.drawValuesEnabled = false
            
            dataSets.append(set)
        }
   

        let data: LineChartData = LineChartData(dataSets: dataSets)
        return  data
    }
    
    func setBottomChartData(values: [Double]){


        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< values.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: values[i]))
            yVals2.append(ChartDataEntry(x: Double(i), y: values[i]))
        }
        if singleView{
            
            let rawDataLine: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Raw X-Axis")
            rawDataLine.setColor(#colorLiteral(red: 0.8692195415, green: 0.3558411002, blue: 0.2854923606, alpha: 1))
            let processedDataLine: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Processed X-Axis")
            processedDataLine.setColor(#colorLiteral(red: 0.2726118863, green: 0.6989091039, blue: 0.6175016761, alpha: 1))
        
            let dataSets = configureDataSet(sets: [rawDataLine,processedDataLine])
            self.BottomLineChartView.data = dataSets
        }else{
            let processedDataLine: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Processed")
            processedDataLine.setColor(#colorLiteral(red: 0.2726118863, green: 0.6989091039, blue: 0.6175016761, alpha: 1))
            let dataSets = configureDataSet(sets: [processedDataLine])
            self.BottomLineChartView.data = dataSets
        }
        
        self.BottomLineChartView.legend.enabled = true
        self.BottomLineChartView.dragEnabled = false
        

       
    }
    
}

