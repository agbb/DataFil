//
//  FilterDetailViewController.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 10/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import UIKit

class FilterDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var filterName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleLabel.text = filterName
        self.navigationItem.title = filterName+" Filter Settings"
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
