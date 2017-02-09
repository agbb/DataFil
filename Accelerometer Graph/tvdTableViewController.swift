//
//  tvdTableViewController.swift
//  Accelerometer_Graph
//
//  Created by Alex Gubbay on 09/02/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

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
            
            if filter.filterName == "Total Variation Denoising" {
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
            fm.addNewFilter(filterName: "Total Variation Denoising")
        }else{
            fm.removeFilter(filterName: "Total Variation Denoising")
        }
    }
   
    @IBAction func lambdaSliderChanged(_ sender: UISlider) {
        
        if tvdSwitch.isOn{
            fm.setFilterParameter(filterName: "Total Variation Denoising", parameterName: "lambda", parameterValue: Double(sender.value))
            lambdaSliderLabel.text = "\(Double(sender.value).roundTo(places: 2))"
        }
    }

    @IBAction func bufferSizeStepperChanged(_ sender: UIStepper) {
        
        if tvdSwitch.isOn{
            fm.setFilterParameter(filterName: "Total Variation Denoising", parameterName: "bufferSize", parameterValue: sender.value)
            bufferStepperLabel.text = "Buffer Size: \(Int(sender.value))"
        }
    }
  

}
