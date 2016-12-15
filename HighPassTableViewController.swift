//
//  HighPassTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 13/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import UIKit

class HighPassTableViewController: UITableViewController {

    let fm = FilterManager.sharedInstance
    @IBOutlet weak var highPassSwitch: UISwitch!
    @IBOutlet weak var currentAlphaLabel: UILabel!
    //@IBOutlet weak var leftSliderLabel: UILabel!
    //@IBOutlet weak var rightSliderLabel: UILabel!
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false

        //leftSliderLabel.font = UIFont.fontAwesome(ofSize: 15)
        //rightSliderLabel.font = UIFont.fontAwesome(ofSize: 15)
        
        //leftSliderLabel.text = String.fontAwesomeIcon(code:"fa-chevron-down")
        //rightSliderLabel.text = String.fontAwesomeIcon(code:"fa-chevron-up")
    }

    @IBAction func highPassSwitchTapped(_ sender: UISwitch) {
        
        
        if sender.isOn{
            fm.addNewFilter(filterName: "High Pass")
        }else{
            
            fm.removeFilter(filterName: "High Pass")
        }
    }
    
    @IBAction func highPassSliderAdjusted(_ sender: UISlider) {
        
        if highPassSwitch.isOn {
            fm.setFilterParameter(filterName: "High Pass", parameterName: "alpha", parameterValue: Double(sender.value))
            currentAlphaLabel.text = String(Double(sender.value).roundTo(places: 2))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
