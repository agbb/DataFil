//
//  SavGolTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 03/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit

class SavGolTableViewController: UITableViewController {

    @IBOutlet weak var savGolSwitch: UISwitch!
    @IBOutlet weak var forwardScanStepper: UIStepper!
    @IBOutlet weak var forwardScanLabel: UILabel!
    @IBOutlet weak var backwardScanStepper: UIStepper!
    @IBOutlet weak var backwardScanLabel: UILabel!
    @IBOutlet weak var smoothingPolSegment: UISegmentedControl!
    let fm = FilterManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for filter in fm.activeFilters{

            if filter.filterName == Algorithm.SavitzkyGolay{
                savGolSwitch.isOn = true
                forwardScanLabel.text = "Forward Scan: \(Int(filter.params["rightScan"]!))"
                backwardScanLabel.text = "Backward Scan: \(Int(filter.params["leftScan"]!))"
                if Int(filter.params["filterPolynomial"]!) == 2{
                    smoothingPolSegment.selectedSegmentIndex = 0
                }else{
                    smoothingPolSegment.selectedSegmentIndex = 1
                }
            }
        }
    }

    @IBAction func savGolSwitchTapped(_ sender: UISwitch) {
        if sender.isOn{
            fm.addNewFilter(algorithmToEnable: Algorithm.SavitzkyGolay)
        }else{
            fm.removeFilter(name: Algorithm.SavitzkyGolay)
        }
    }
    
    @IBAction func forwardScanStepperTapped(_ sender: UIStepper) {
        
        fm.setFilterParameter(filterName: Algorithm.SavitzkyGolay, parameterName: "rightScan", parameterValue: sender.value)
      
        forwardScanLabel.text = "Forward Scan: \(Int(sender.value))"
    }
    
    @IBAction func backwardScanStepperTapped(_ sender: UIStepper) {
        fm.setFilterParameter(filterName: Algorithm.SavitzkyGolay, parameterName: "leftScan", parameterValue: sender.value)
        backwardScanLabel.text = "Backward Scan: \(Int(sender.value))"
    }
    
    @IBAction func smoothingPolSegTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            
            fm.setFilterParameter(filterName: Algorithm.SavitzkyGolay, parameterName: "filterPolynomial", parameterValue: 2)
        }else{
            fm.setFilterParameter(filterName: Algorithm.SavitzkyGolay, parameterName: "filterPolynomial", parameterValue: 4)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
