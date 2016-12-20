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
