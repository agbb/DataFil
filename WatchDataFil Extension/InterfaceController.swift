//
//  InterfaceController.swift
//  WatchDataFil Extension
//
//  Created by Alex Gubbay on 12/03/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    var active = false
    let accel = DataSourceManager.init(sourceId: "watch")

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var sampleRateSlider: WKInterfaceSlider!
    @IBOutlet var dataBatchingSlider: WKInterfaceSlider!

    @IBAction func startButtonPressed() {

        if !active{
            RemoteCommunicator.sharedInstance.start(deviceId: "watch")

            accel.initaliseDatasources()
            RemoteDataInterface.sharedInstance.publishOutgoingData()
            startButton.setTitle("Stop")
            active = true
        }else{
            accel.initaliseDatasources()
            startButton.setTitle("Start")
            active = false
        }
    }
    @IBAction func sampleRateAdjusted(_ value: Float) {

        if value == 0{
            accel.sampleRate = 10

        }else if value == 1{
            accel.sampleRate = 20

        }else if value == 2{
            accel.sampleRate = 40

        }else{
            accel.sampleRate = 60
        }
    }

    @IBAction func dataBatchingAdjusted(_ value: Float) {
        print("here")
        if value == 0{
            RemoteDataInterface.sharedInstance.sampleBuffer = 0
            print(0)
        }else if value == 1{
            RemoteDataInterface.sharedInstance.sampleBuffer = 15
            print(15)
        }else if value == 2{
            RemoteDataInterface.sharedInstance.sampleBuffer = 30
            print(30)
        }else{
            RemoteDataInterface.sharedInstance.sampleBuffer = 60
            print(60)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
