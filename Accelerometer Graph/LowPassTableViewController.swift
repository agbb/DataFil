//
//  LowPassTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 20/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import UIKit

class LowPassTableViewController: UITableViewController {

    let fm = FilterManager.sharedInstance

    
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    
    @IBOutlet weak var lowPassSwitch: UISwitch!
    
    @IBAction func pValueChanged(_ sender: UIStepper) {
        pLabel.text = "P: \(sender.value)"
        if lowPassSwitch.isOn{
            fm.setFilterParameter(filterName: "Low Pass", parameterName: "p", parameterValue: sender.value)
        }
    }
   
    
    @IBAction func gValueChanged(_ sender: UIStepper) {
        gLabel.text = "G: \(sender.value)"
        if lowPassSwitch.isOn{
            fm.setFilterParameter(filterName: "Low Pass", parameterName: "g", parameterValue: sender.value)
        }
    }
    
    @IBAction func passesValueChanged(_ sender: UISegmentedControl) {
        if lowPassSwitch.isOn{
            fm.setFilterParameter(filterName: "Low Pass", parameterName: "n", parameterValue: Double(sender.selectedSegmentIndex+1))
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func LowPassSwitchTapped(_ sender: UISwitch) {
        
        if sender.isOn{
            fm.addNewFilter(filterName: "Low Pass")
        }else{
            
            fm.removeFilter(filterName: "Low Pass")
        }
        
    }
}
