//
//  FilterTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 08/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    private let filterDisplayNames = ["High Pass","Low Pass","Bounded Average","Savitzky Golay"]
    private let filterViewControllerNames = ["HighPassTableView","LowPassTableView","BoundedAverageTableView","SavGolTableView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Filters"
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
        return filterDisplayNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
    
        // Configure the cell...
        print(indexPath.row)
        cell.textLabel?.text = filterDisplayNames[indexPath.row]
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let destination = Storyboard.instantiateViewController(withIdentifier: filterViewControllerNames[indexPath.row])
        navigationController?.pushViewController(destination, animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
    //}
    

}
