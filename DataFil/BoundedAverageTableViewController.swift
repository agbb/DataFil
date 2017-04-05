//
//  BoundedAverageTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 25/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

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
            
            if filter.filterName == "Bounded Average" {
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
            
            fm.removeFilter(filterName: "Bounded Average")
        }
        
    }
    @IBAction func movingAverageSliderAdjusted(_ sender: UISlider){
        if boundedAverageSwitch.isOn {
            fm.setFilterParameter(filterName: "Bounded Average", parameterName: "points", parameterValue: Double(sender.value).roundTo(places: 0))
            movingAverageLabel.text = String(Int(sender.value))
        }
    }
 
    @IBAction func bandsizeSliderAdjusted(_ sender: UISlider) {
        
        if boundedAverageSwitch.isOn {
            fm.setFilterParameter(filterName: "Bounded Average", parameterName: "upperBound", parameterValue: Double(sender.value))
            fm.setFilterParameter(filterName: "Bounded Average", parameterName: "lowerBound", parameterValue: Double(sender.value))
            currentBandSizeLabel.text = String(Double(sender.value).roundTo(places: 2))
        }
        
    }

}
