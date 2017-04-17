//
//  LowPassTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 20/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit

class LowPassTableViewController: UITableViewController {

    let fm = FilterManager.sharedInstance
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var pStepper: UIStepper!
    @IBOutlet weak var gStepper: UIStepper!
    @IBOutlet weak var passesSegment: UISegmentedControl!
    
    @IBOutlet weak var lowPassSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for filter in fm.activeFilters{
            
            if filter.filterName == Algorithm.LowPass{
                lowPassSwitch.isOn = true
                pLabel.text = "P: \(Double(filter.params["p"]!).roundTo(places: 2))"
                gLabel.text = "G: \(Double(filter.params["g"]!).roundTo(places: 2))"
                passesSegment.selectedSegmentIndex = (Int(filter.params["n"]!)-1)
            }
        }
    }
    @IBAction func pValueChanged(_ sender: UIStepper) {
        pLabel.text = "P: \(sender.value)"
        if lowPassSwitch.isOn{
            fm.setFilterParameter(filterName: Algorithm.LowPass, parameterName: "p", parameterValue: sender.value)
        }
    }

    @IBAction func gValueChanged(_ sender: UIStepper) {
        gLabel.text = "G: \(sender.value)"
        if lowPassSwitch.isOn{
            fm.setFilterParameter(filterName: Algorithm.LowPass, parameterName: "g", parameterValue: sender.value)
        }
    }
    @IBAction func passesValueChanged(_ sender: UISegmentedControl) {
        if lowPassSwitch.isOn{
            fm.setFilterParameter(filterName: Algorithm.LowPass, parameterName: "n", parameterValue: Double(sender.selectedSegmentIndex+1))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func LowPassSwitchTapped(_ sender: UISwitch) {
        
        if sender.isOn{
            fm.addNewFilter(algorithmToEnable: Algorithm.LowPass)
        }else{
            
            fm.removeFilter(name: Algorithm.LowPass)
        }
    }
}
