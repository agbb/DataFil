//
//  WatchViewController.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import UIKit

class WatchViewController: UIViewController {


    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }
    @IBAction func startButtonTapped(_ sender: Any) {
        remoteCommunicator.sharedInstance.start(deviceId: "device")
        remoteDataInterface.sharedInstance.subscribeIncomingData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.newRemoteData), name: Notification.Name("newRemoteData"), object: nil)
    }


    func newRemoteData(notification: NSNotification){
        //print(i)
        i += 1

        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]
        print(accelData?.count)
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
