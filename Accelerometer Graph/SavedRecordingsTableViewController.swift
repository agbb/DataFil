//
//  SavedRecordingsTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 21/01/2017.
//  Copyright © 2017 Alex Gubbay. All rights reserved.
//

import UIKit
import MessageUI

class SavedRecordingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var data = storage().fetchRecordings()
    var labelMappings = [String:Date]()
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let jsonRecording = storage().fetchRecordingWithDate(date:date!).json
        if(jsonRecording.contains("NO DATA")){
            let csvRecording = storage().fetchRecordingWithDate(date:date!).csv
            displayEmailController(attachment: csvRecording, date: date!)
        }else{
            
            displayEmailController(attachment: jsonRecording, date: date!)
            
        }
        
        //Convert json string to data that can be sent.
        
        
        
    }
    
    //Display the email composer popover to export data
    func displayEmailController(attachment:String, date:Date){
        
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
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
             let date = labelMappings.removeValue(forKey: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
            storage().removeRecordingWithDate(date: date!)
            data = storage().fetchRecordings()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }     
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
