//
//  dataCaptureTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 17/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import UIKit

class dataCaptureTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var minuteData = [["0","1","2","3","4","5"],["0","10","20","30","40","50"]]
    var minuteSelection = 0.0
    var secondSelection = 0.0
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.dataSource = self
        self.pickerView.delegate = self

        pickerView.selectRow(2, inComponent: 0, animated: true)
        pickerView.selectRow(3, inComponent: 1, animated: true)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
    func numberOfComponents(in: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_: UIPickerView, numberOfRowsInComponent: Int) -> Int {
        return minuteData[0].count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return minuteData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if component == 0 {
            let minString = minuteData[0][row]
            minuteSelection = Double(minString)!
        }else{
            let secString = minuteData[1][row]
            secondSelection = Double(secString)!
        }
        print("woop")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
