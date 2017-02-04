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
        
        return 2
    }

    @IBAction func graphLayoutSwitched(_ sender: UISwitch) {
     
        notify()
        
    }
    @IBAction func graphPointsChanged(_ sender: UISegmentedControl) {
        
        notify()
        
    }
   
    func notify(){
        let number = (pointCountSelector.selectedSegmentIndex + 1) * 100
        NotificationCenter.default.post(name: Notification.Name("newGraphSettings"), object: nil, userInfo:["singleView":singleGraphSelection.isOn,"pointsCount":number])
    }

}
