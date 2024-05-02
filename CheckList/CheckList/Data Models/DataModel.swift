//
//  DataModel.swift
//  CheckList
//
//  Created by Daniele Perrupane on 17/04/24.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    
    /* This method gets the current ChecklistItemID value from UserDefaults, adds 1 to it
    and writes it back to UserDefaults. It returns the previous value to the caller */
    class func nextChecklistItemID() -> Int {
       /* The inclusion of the class keyword in the method name indicates a class metho -
        this kind of method applies to the class as a whole. The instance method, instead, works only on a specific instance of that class. */
        
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        
        return itemID
    }
    
    func sortChecklists() {
        lists.sort {list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1, "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
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
    
    func saveChecklist() {
        let encoder = PropertyListEncoder()
        do {
            //Encode list instead of items
            let data = try encoder.encode(lists)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                //You decode to an object of [Checklist] type to lists
                lists = try decoder.decode(
                    [Checklist].self,
                    from: data)
                sortChecklists()
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
}
