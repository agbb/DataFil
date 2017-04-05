//
//  tvdTableViewController.swift
//  Accelerometer_Graph
//
//  Created by Alex Gubbay on 09/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit

class tvdTableViewController: UITableViewController {

    
    @IBOutlet weak var tvdSwitch: UISwitch!
    @IBOutlet weak var lambdaSlider: UISlider!
    @IBOutlet weak var bufferStepper: UIStepper!
    @IBOutlet weak var bufferStepperLabel: UILabel!
    @IBOutlet weak var lambdaSliderLabel: UILabel!
    
    let fm = FilterManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for filter in fm.activeFilters{
            
            if filter.filterName == Algorithm.TotalVariation {
                tvdSwitch.isOn = true
                lambdaSlider.value = Float(filter.params["lambda"]!)
                bufferStepperLabel.text = "Buffer Size: \(Int(filter.params["bufferSize"]!))"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tvdSwitchTapped(_ sender: UISwitch) {
        
        if sender.isOn{
            fm.addNewFilter(algorithmToEnable: Algorithm.TotalVariation)
        }else{
            fm.removeFilter(name: Algorithm.TotalVariation)
        }
    }
   
    @IBAction func lambdaSliderChanged(_ sender: UISlider) {
        
        if tvdSwitch.isOn{
            fm.setFilterParameter(filterName: Algorithm.TotalVariation, parameterName: "lambda", parameterValue: Double(sender.value))
            lambdaSliderLabel.text = "\(Double(sender.value).roundTo(places: 2))"
        }
    }

    @IBAction func bufferSizeStepperChanged(_ sender: UIStepper) {
        
        if tvdSwitch.isOn{
            fm.setFilterParameter(filterName: Algorithm.TotalVariation, parameterName: "bufferSize", parameterValue: sender.value)
            bufferStepperLabel.text = "Buffer Size: \(Int(sender.value))"
        }
    }
  

}
