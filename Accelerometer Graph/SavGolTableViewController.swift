//
//  SavGolTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 03/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

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
        print("here")
        for filter in fm.activeFilters{
            print("here")
            if filter.filterName == "Savitzky Golay" {
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
            fm.addNewFilter(filterName: "Savitzky Golay")
        }else{
            fm.removeFilter(filterName: "Savitzky Golay")
        }
    }
    
    @IBAction func forwardScanStepperTapped(_ sender: UIStepper) {
        
        fm.setFilterParameter(filterName: "Savitzky Golay", parameterName: "rightScan", parameterValue: sender.value)
      
        forwardScanLabel.text = "Forward Scan: \(Int(sender.value))"
    }
    
    @IBAction func backwardScanStepperTapped(_ sender: UIStepper) {
        fm.setFilterParameter(filterName: "Savitzky Golay", parameterName: "leftScan", parameterValue: sender.value)
        backwardScanLabel.text = "Backward Scan: \(Int(sender.value))"
    }
    
    @IBAction func smoothingPolSegTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            
            fm.setFilterParameter(filterName: "Savitzky Golay", parameterName: "filterPolynomial", parameterValue: 2)
        }else{
            fm.setFilterParameter(filterName: "Savitzky Golay", parameterName: "filterPolynomial", parameterValue: 4)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  

}
