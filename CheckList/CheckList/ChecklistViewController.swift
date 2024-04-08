//
//  ViewController.swift
//  CheckList
//
//  Created by Daniele Perrupane on 08/04/24.
//

import UIKit

class ChecklistViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //TableView Data Source
    
    //This tells the table view that you have just one row of data
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 100
    }
    
    //This method grabs a copy of the prototype cell and gives that back to the table view
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
        
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        if indexPath.row % 5 == 0 {
            label.text = "Walk the dog"
        } else if indexPath.row % 5 == 1 {
            label.text = "Brush my teeth"
        } else if indexPath.row % 5  == 2 {
            label.text = "Learn iOS development"
        } else if indexPath.row % 5  == 3 {
            label.text = "soccer Practice"
        } else if indexPath.row % 5  == 4 {
            label.text = "Eat ice cream"
        }
        
        return cell
    }


}

