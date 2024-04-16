//
//  ViewController.swift
//  CheckList
//
//  Created by Daniele Perrupane on 08/04/24.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    
    
    
    var items = [ChecklistItem]()
    //var checklist: Checklist!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Disables large titles for this view controller
        navigationItem.largeTitleDisplayMode = .never
        
        //Load items
        loadChecklistItems()
        
        //title = checklist.name
        
        
    }
    
    //MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        //1
        if segue.identifier == "AddItem" {
            //2
            let controller = segue.destination as! ItemDetailViewController
            //3
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    //MARK: - Add Item ViewController Delegates
    func itemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController) {
            navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem) {
            
            let newRowIndex = items.count
            items.append(item)
            
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            tableView.insertRows(at: indexPaths, with: .automatic)
            navigationController?.popViewController(animated: true)
            
            saveChecklistItems()
    }
    
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem
    ){
        if let index = items.firstIndex(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    //MARK: - Methods
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "✔️"
        } else {
            label.text = ""
        }
    }
    
    func configureText(
        
        for cell: UITableViewCell,
        with item: ChecklistItem
        
    ){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        //1
        let encoder = PropertyListEncoder()
        //2
        do{
            //3
            let data = try encoder.encode(items)
            //4
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
            //5
        } catch {
            //6
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        //1
        let path = dataFilePath()
        //2
        if let data = try? Data(contentsOf: path) {
            //3
            let decoder = PropertyListDecoder()
            do {
                //4
                items = try decoder.decode(
                    [ChecklistItem].self,
                    from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: - TableView Data Source
    
    //This tells the table view that you have just n row of data
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    //This method grabs a copy of the prototype cell and gives that back to the table view
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    //MARK: - Table View Delegate
    
    //A method that is called whenever the user tap on a cell
    //this helps managing the tap on a cell to turn back
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        //Let's make the method work with the checkmark
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        //deselect the cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveChecklistItems()
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            //1 Remove the item from the data model
            items.remove(at: indexPath.row)
            
            //2 Delete the corrisponding row from the table view
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            
            saveChecklistItems()
        }
    
    
}

