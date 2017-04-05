//
//  HighPassTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 13/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */

import UIKit

class HighPassTableViewController: UITableViewController {

    private let fm = FilterManager.sharedInstance
    @IBOutlet weak var highPassSwitch: UISwitch!
    @IBOutlet weak var currentAlphaLabel: UILabel!
    @IBOutlet weak var currentAlphaSlider: UISlider!

    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        for filter in fm.activeFilters{
            
            if filter.filterName == Algorithm.HighPass {
                highPassSwitch.isOn = true
                currentAlphaLabel.text = "\(Double(filter.params["cutPoint"]!).roundTo(places: 2))"
                currentAlphaSlider.value = Float(filter.params["cutPoint"]!)
            }
        }

    }

    @IBAction func highPassSwitchTapped(_ sender: UISwitch) {
        
        
        if sender.isOn{
            fm.addNewFilter(algorithmToEnable: Algorithm.HighPass)
        }else{
            
            fm.removeFilter(name: Algorithm.HighPass)
        }
    }
    
    @IBAction func highPassSliderAdjusted(_ sender: UISlider) {
        
        if highPassSwitch.isOn {
            fm.setFilterParameter(filterName: Algorithm.HighPass, parameterName: "cutPoint", parameterValue: Double(sender.value))
            currentAlphaLabel.text = String(Double(sender.value).roundTo(places: 2))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
