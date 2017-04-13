//
//  graphSettingsTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 27/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit



class graphSettingsTableViewController: UITableViewController {


    @IBOutlet weak var pointCountSelector: UISegmentedControl!
    @IBOutlet weak var singleGraphSelection: UISwitch!
    @IBOutlet weak var sampleRateSelection: UISegmentedControl!
    @IBOutlet weak var autoScale: UISwitch!
    @IBOutlet weak var dataSourceSelection: UISegmentedControl!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        singleGraphSelection.setOn(utilities.singleView, animated: false)
        pointCountSelector.selectedSegmentIndex = (utilities.pointCount/100)-1
         dataSourceSelection.isEnabled = true//RemoteCommunicator.sharedInstance.watchIsConnected() //&& RemoteDataInterface.sharedInstance.isListening
    }

    override func viewDidAppear(_ animated: Bool) {
         dataSourceSelection.isEnabled = true//RemoteCommunicator.sharedInstance.watchIsConnected() //&& RemoteDataInterface.sharedInstance.isListening
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func dataSourceSelectionDidChange(_ sender: UISegmentedControl) {
        notifyGraphSettings()
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
        NotificationCenter.default.post(name: Notification.Name("newGraphSettings"), object: nil, userInfo:["singleView":singleGraphSelection.isOn,"pointsCount":number,"autoScale":autoScale.isOn,"remoteSource":(dataSourceSelection.selectedSegmentIndex==1)])
        print("notifying \((dataSourceSelection.selectedSegmentIndex==1))")
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
        NotificationCenter.default.post(name: Notification.Name("newDatasourceSettings"), object: nil, userInfo:["sampleRate":sampleRate])
        
    }

}
