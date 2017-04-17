//
//  FilterTableViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 08/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//
/*
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 The software implementation below is NOT designed to be used in any situation where the failure of the algorithms code on which they rely or mathematical assumptions made therin could lead to the harm of the user or others, property or the environment. It is NOT designed to prevent silent failures or fail safe.
 */
import UIKit

class FilterTableViewController: UITableViewController {

    private let filterDisplayNames = ["High Pass","Low Pass","Bounded Average","Savitzky Golay","Total Variation Denoising"]
    private let filterViewControllerNames = ["HighPassTableView","LowPassTableView","BoundedAverageTableView","SavGolTableView","tvdTableView"]
    
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
        cell.textLabel?.text = filterDisplayNames[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let destination = Storyboard.instantiateViewController(withIdentifier: filterViewControllerNames[indexPath.row])
        navigationController?.pushViewController(destination, animated: true)
    }
}
