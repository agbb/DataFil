//
//  TimePickerViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 17/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var minuteData = [["0","1","2","3","4","5"],["0","10","20","30","40","50"]]
    var section1Row = 0
    var section2Row = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if(row == 0){
        
    }
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
