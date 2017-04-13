//
//  WatchViewController.swift
//  DataFil
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit

class WatchViewController: UIViewController {


    @IBOutlet weak var installedLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var listeningLabel: UILabel!
    
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        RemoteCommunicator.sharedInstance.start(deviceId: "device")
        updateConnectionStatus()

        // Do any additional setup after loading the view.
    }
    
    func updateConnectionStatus(){
        
        let remote = RemoteCommunicator.sharedInstance
        
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
            if RemoteDataInterface.sharedInstance.isListening{
                listeningLabel.text = "YES"
                listeningLabel.textColor = #colorLiteral(red: 0.3221009754, green: 0.8941736817, blue: 0.4154235909, alpha: 1)
            }else{
                listeningLabel.text = "NO"
                listeningLabel.textColor = #colorLiteral(red: 0.8941736817, green: 0.2608122561, blue: 0.2661629297, alpha: 1)
            }
    
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        
        RemoteDataInterface.sharedInstance.subscribeIncomingData()
        updateConnectionStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
