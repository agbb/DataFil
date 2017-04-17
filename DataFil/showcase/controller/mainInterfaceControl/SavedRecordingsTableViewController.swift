//
//  SavedRecordingsTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 21/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit
import MessageUI

class SavedRecordingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var data = Storage().fetchRecordings()
    var labelMappings = [String:Date]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
  
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell", for: indexPath)

        cell.textLabel?.text = "\(data[indexPath.row].Date)"
        labelMappings["\(data[indexPath.row].Date)"] = data[indexPath.row].Date
        cell.textLabel?.textColor = #colorLiteral(red: 0.8940202594, green: 0.8941736817, blue: 0.8940106034, alpha: 1)
        // Configure the cell...
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        let date = labelMappings[(tableView.cellForRow(at: indexPath)?.textLabel?.text)!]
        let jsonRecording = Storage().fetchRecordingWithDate(date:date!).json
        if(jsonRecording.contains("NO DATA")){
            let csvRecording = Storage().fetchRecordingWithDate(date:date!).csv
            displayEmailController(attachment: csvRecording, date: date!)
        }else{
            displayEmailController(attachment: jsonRecording, date: date!)
        }
    }
    
    //Display the email composer popover to export data
    private func displayEmailController(attachment:String, date:Date){
        
        let data = NSMutableString(string:attachment).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setSubject("Capture From Accelerometer")
        email.setMessageBody("Recorded at \(date)", isHTML: false)
        email.addAttachmentData(data!, mimeType: "text", fileName: "Capture\(date).txt")
        
        if MFMailComposeViewController.canSendMail() {
            self.present(email, animated: true, completion: nil)
        }
    }
    
     // Dismiss the mail compose view controller.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
             let date = labelMappings.removeValue(forKey: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
            Storage().removeRecordingWithDate(date: date!)
            data = Storage().fetchRecordings()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }     
    }
}
