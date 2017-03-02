//
//  graphSettingsTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 27/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import UIKit



class graphSettingsTableViewController: UITableViewController {


    @IBOutlet weak var pointCountSelector: UISegmentedControl!
    @IBOutlet weak var singleGraphSelection: UISwitch!
    @IBOutlet weak var sampleRateSelection: UISegmentedControl!
    @IBOutlet weak var autoScale: UISwitch!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        singleGraphSelection.setOn(utilities.singleView, animated: false)
        pointCountSelector.selectedSegmentIndex = (utilities.pointCount/100)-1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }

    @IBAction func graphLayoutSwitched(_ sender: UISwitch) {
     
        notifyGraphSettings()
        
    }
    @IBAction func graphPointsChanged(_ sender: UISegmentedControl) {
        
        notifyGraphSettings()
        
    }
    
    @IBAction func autoScaleSwitched(_ sender: UISwitch) {
        
        notifyGraphSettings()
    }
    
    @IBAction func sampleRateChanged(_ sender: UISegmentedControl) {
        
        notifyDatasourceSettings()
    }
   
    func notifyGraphSettings(){
        let number = (pointCountSelector.selectedSegmentIndex + 1) * 100
        NotificationCenter.default.post(name: Notification.Name("newGraphSettings"), object: nil, userInfo:["singleView":singleGraphSelection.isOn,"pointsCount":number,"autoScale":autoScale.isOn])
    }
    
    func notifyDatasourceSettings(){
        
        var sampleRate = 10.0
        if sampleRateSelection.selectedSegmentIndex == 1{
            sampleRate = 30.0
        }else if sampleRateSelection.selectedSegmentIndex == 2{
            sampleRate = 60.0
        }else if  sampleRateSelection.selectedSegmentIndex == 3{
            sampleRate = 100.0
        }
        print("psoting")
        NotificationCenter.default.post(name: Notification.Name("newDatasourceSettings"), object: nil, userInfo:["sampleRate":sampleRate])
        
    }

}
