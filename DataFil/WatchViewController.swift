//
//  WatchViewController.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import UIKit

class WatchViewController: UIViewController {


    @IBOutlet weak var installedLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var listeningLabel: UILabel!
    
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        remoteCommunicator.sharedInstance.start(deviceId: "device")
        updateConnectionStatus()

        // Do any additional setup after loading the view.
    }
    
    func updateConnectionStatus(){
        
        let remote = remoteCommunicator.sharedInstance
        
            if remote.session.isWatchAppInstalled {
                installedLabel.text = "YES"
                installedLabel.textColor = #colorLiteral(red: 0.3221009754, green: 0.8941736817, blue: 0.4154235909, alpha: 1)
            }else{
                installedLabel.text = "NO"
                installedLabel.textColor = #colorLiteral(red: 0.8941736817, green: 0.2608122561, blue: 0.2661629297, alpha: 1)
            }
            if remote.isSupported() {
                connectionLabel.text = "YES"
                connectionLabel.textColor = #colorLiteral(red: 0.3221009754, green: 0.8941736817, blue: 0.4154235909, alpha: 1)
            }else{
                connectionLabel.text = "NO"
                connectionLabel.textColor = #colorLiteral(red: 0.8941736817, green: 0.2608122561, blue: 0.2661629297, alpha: 1)
            }
            if remoteDataInterface.sharedInstance.isListening{
                listeningLabel.text = "YES"
                listeningLabel.textColor = #colorLiteral(red: 0.3221009754, green: 0.8941736817, blue: 0.4154235909, alpha: 1)
            }else{
                listeningLabel.text = "NO"
                listeningLabel.textColor = #colorLiteral(red: 0.8941736817, green: 0.2608122561, blue: 0.2661629297, alpha: 1)
            }
    
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
        remoteDataInterface.sharedInstance.subscribeIncomingData()
        i = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.newRemoteData), name: Notification.Name("newRemoteData"), object: nil)
        i = 0
        updateConnectionStatus()
    }


    func newRemoteData(notification: NSNotification){
        i += 1
        
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
