//
//  BoundedAverageTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 25/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit

class BoundedAverageTableViewController: UITableViewController {

    
    private let fm = FilterManager.sharedInstance
    
    @IBOutlet weak var currentBandSlider: UISlider!
    @IBOutlet var boundedAverageSwitch: UISwitch!
    @IBOutlet var currentBandSizeLabel: UILabel!
    @IBOutlet weak var movingAverageSlider: UISlider!
    @IBOutlet weak var movingAverageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for filter in fm.activeFilters{
            
            if filter.filterName == Algorithm.BoundedAverage{
                boundedAverageSwitch.isOn = true
                currentBandSizeLabel.text = "\(Double(filter.params["upperBound"]!).roundTo(places: 2))"
                currentBandSlider.value = Float(filter.params["upperBound"]!)
                movingAverageLabel.text = "\(Int(filter.params["points"]!))"
                movingAverageSlider.value = Float(filter.params["points"]!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func boundedAverageTapped(_ sender: UISwitch) {
        
        if sender.isOn{
            fm.addNewFilter(algorithmToEnable: Algorithm.BoundedAverage)
        }else{
            
            fm.removeFilter(name: Algorithm.BoundedAverage)
        }
        
    }
    @IBAction func movingAverageSliderAdjusted(_ sender: UISlider){
        if boundedAverageSwitch.isOn {
            fm.setFilterParameter(filterName: Algorithm.BoundedAverage, parameterName: "points", parameterValue: Double(sender.value).roundTo(places: 0))
            movingAverageLabel.text = String(Int(sender.value))
        }
    }
 
    @IBAction func bandsizeSliderAdjusted(_ sender: UISlider) {
        
        if boundedAverageSwitch.isOn {
            fm.setFilterParameter(filterName: Algorithm.BoundedAverage, parameterName: "upperBound", parameterValue: Double(sender.value))
            fm.setFilterParameter(filterName: Algorithm.BoundedAverage, parameterName: "lowerBound", parameterValue: Double(sender.value))
            currentBandSizeLabel.text = String(Double(sender.value).roundTo(places: 2))
        }
        
    }

}
