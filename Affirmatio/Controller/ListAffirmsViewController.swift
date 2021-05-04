//
//  ListAffirmsViewController.swift
//  Affirmatio
//
//  Created by evpes on 25.04.2021.
//

import UIKit
import RealmSwift

class ListAffirmsViewController: UITableViewController {

    let realm = try! Realm()
    
    var affirmsList : AffirmationsList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let list = affirmsList {
            print(list)
            return list.affirmations.count + 1
        }
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        if let list = affirmsList {
            if indexPath.row > list.affirmations.count - 1 {
                cell.textLabel?.text = " + add affirmations"
                cell.textLabel?.textColor = .gray
            } else {
            cell.textLabel?.text = list.affirmations[indexPath.row].affitmText
                cell.textLabel?.textColor = .black
            }
        } else {
            cell.textLabel?.text = " + add affirmations"
            cell.textLabel?.textColor = .gray
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            print("delete")
            deleteAffirm(path: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == affirmsList?.affirmations.count {
            performSegue(withIdentifier: "fromListToCategories", sender: self)
        }
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromListToCategories" {
            let vc = segue.destination as! AffirmCategoriesViewController
            vc.currentList = affirmsList
            vc.lastVC = self
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Data manipilation methods
    
    func deleteAffirm(path: IndexPath) {
        if let affrim = affirmsList?.affirmations[path.row] {
            do {
                try realm.write {
                    affirmsList?.affirmations.remove(at: path.row)
                }
            } catch  {
                print("Error during delete affirmation from list: \(error)")
            }
        }
        
    }

}
