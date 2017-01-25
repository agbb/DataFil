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
    var minuteSelection = 2.0
    var secondSelection = 30.0
    var raw = true
    var processed = true
    var record = recorder()
    var timeRemaining = 0.0
    var totalTime = 0.0

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var exportSelection: UISegmentedControl!
    
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
        return 1
    }
    @IBAction func recordPressed(_ sender: UIButton) {
        print("press")
        timeRemaining = (minuteSelection * 60) + secondSelection
        totalTime = timeRemaining
        
        if timeRemaining == 0.0{
            
            let alert = alertBuilder().build(title: "Invalid time", message: "Select a valid time for recording.", buttonText: "OK")
            self.present(alert, animated: true, completion: nil)
            
        }else if raw == false && processed == false{
            
            let alert = alertBuilder().build(title:"No data selected", message:"Select at least one data type for recording.", buttonText:"OK")
            self.present(alert, animated: true, completion: nil)

        }else{
            
            let exportJson = (exportSelection.selectedSegmentIndex == 0)
            spinner.startAnimating()
            recordButton.isHidden = true
            record.beginRecording(raw:self.raw, processed:self.processed, time:Double(timeRemaining), json: exportJson)
            
            
            
            let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                if(self.timeRemaining > 0){
                    self.timeRemaining -= 1

                    self.progressBar.setProgress(Float(1.0 - (self.timeRemaining/self.totalTime)), animated: true)
                }else{
                    
                    let alert = alertBuilder().build(title:"Recording Complete", message:"The capture has been saved in the \"Saved Captures\" section.", buttonText:"OK")
                    self.present(alert, animated: true, completion: nil)
                    self.progressBar.setProgress(Float(0.0), animated: false)
                    self.spinner.stopAnimating()
                    self.recordButton.isHidden = false
                    Timer.invalidate()
                    self.allowTable(modification: true)
                }
            })
            

            allowTable(modification: false)
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    func allowTable(modification:Bool){
        self.tableView.allowsSelection = modification
        self.pickerView.isUserInteractionEnabled = modification
        for cell in self.tableView.visibleCells{
            cell.isUserInteractionEnabled = modification
        }
        recordButton.isUserInteractionEnabled = modification
    }
    
    
    func numberOfComponents(in: UIPickerView) -> Int {
        return 2
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        if indexPath.row==3 {
            let cell = tableView.cellForRow(at: indexPath)
            if processed {
                cell?.accessoryType = .none
                processed = false
            }else{
                cell?.accessoryType = .checkmark
                processed = true
            }
        }
        if indexPath.row == 2 {
            let cell = tableView.cellForRow(at: indexPath)
            if raw {
                cell?.accessoryType = .none
                raw = false
            }else{
                cell?.accessoryType = .checkmark
                raw = true
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 {
            let cell = tableView.cellForRow(at: indexPath)
            if processed {
                cell?.accessoryType = .none
                processed = false
            }else{
                cell?.accessoryType = .checkmark
                processed = true
            }
        }
        if indexPath.row == 2 {
            let cell = tableView.cellForRow(at: indexPath)
            if raw {
                cell?.accessoryType = .none
                raw = false
            }else{
                cell?.accessoryType = .checkmark
                raw = true
            }
        }
    }
    
    //MARK: Picker view data source
    
    func pickerView(_: UIPickerView, numberOfRowsInComponent: Int) -> Int {
        return minuteData[0].count;
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = minuteData[component][row]
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:#colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)])
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
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        //Deselect the sending tableview cell.
        tableView.deselectRow(at: tableView.indexPath(for: (sender as! UITableViewCell))!, animated: true)
    }
    

}
