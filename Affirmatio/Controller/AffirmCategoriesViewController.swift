//
//  AffirmCategoriesViewController.swift
//  Affirmatio
//
//  Created by evpes on 24.04.2021.
//

import UIKit
import RealmSwift

class AffirmCategoriesViewController: UITableViewController {
    
    var lastVC: UITableViewController?
    var categories: Results<AffirmationsCategory>?
    //var affirmations: [String : Affirmation] = [:]
    var currentList: AffirmationsList?
    var listName: String?
    let realm = try! Realm()
    var expandArray : [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        if let cat = categories {
            for _ in cat {
                expandArray.append(false)
            }
        }
        tableView.register(CategoryHeaderView.self,
               forHeaderFooterViewReuseIdentifier: "sectionHeader")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !expandArray[section] {
            let res = 0
            print("innser res: \(res) for sec: \(section)")
            return res
        } else {
        let res = categories?[section].affirmations.count ?? 0
            print("outer res: \(res) for sec: \(section)")
            return res
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories?[section].name
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cat = categories {
            if let cell = tableView.cellForRow(at: indexPath) {
                
                if cell.accessoryType == .none {
                    print("none")
                    let affirmation = cat[indexPath.section].affirmations[indexPath.row]
                    appendAffirm(affirm: affirmation)
                    tableView.reloadData()
                } else {
                    let affirmation = cat[indexPath.section].affirmations[indexPath.row]
                    deleteAffirm(affirm: affirmation)
                    tableView.reloadData()
                }

            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        if let cat = categories {
            print("sec \(indexPath.section) row \(indexPath.row)")
            let text = cat[indexPath.section].affirmations[indexPath.row].affitmText
            cell.textLabel?.text = text
            //.filter("check == %@", false)
            print(currentList)
            let array = Array(currentList!.affirmations)
            print(array)
            if  currentList!.affirmations.filter("affitmText = %@", text).count > 0 {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! CategoryHeaderView
        //view.title.text = categories?[section].name
        view.button.tag = section
        view.button.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
        //        let button = UIButton(type: .system)
//        button.setTitle("Close", for: .normal)
//        button.backgroundColor = .yellow
//        button.setTitleColor(.black, for: .normal)
        view.button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
//        button.tag = section
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.masksToBounds = true
        //let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        view.image.image = UIImage(named: "work\(section).jpg")
        view.image.contentMode = .scaleAspectFill
        view.image.layer.cornerRadius = 15
        view.image.layer.cornerRadius = 15
        view.image.layer.borderWidth = 2
        view.image.layer.borderColor = UIColor.clear.cgColor
        view.image.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.tintColor = .clear
        //contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, margins)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return .leastNormalMagnitude
//    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Try close section")
        let section = button.tag
        let headerView = tableView.headerView(forSection: section) as! CategoryHeaderView
        var indexPaths : [IndexPath] = []
        
        
        
        if let cat = categories {
            for row in cat[section].affirmations.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
        }
        
        let isExpanded = expandArray[section]
        expandArray[section] = !isExpanded
        print("categories: \(categories)")
        //tableView.reloadData()
        
        if isExpanded {
            print("isExp")
            tableView.deleteRows(at: indexPaths, with: .fade)
            
            headerView.button.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
            //tableView.reloadData()
        } else {
            print("!isExp")
            tableView.insertRows(at: indexPaths, with: .fade)
            headerView.button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            
            //tableView.reloadData()
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    
    // MARK: - Data manipilation methods
    
    func loadCategories() {
        categories = realm.objects(AffirmationsCategory.self)
    }
    
    func appendAffirm(affirm: Affirmation) {
        do {
            try realm.write {
                currentList?.affirmations.append(affirm)
            }
        } catch {
            print("Error while append new affirm: \(error)")
        }
    }
    
    func deleteAffirm(affirm: Affirmation) {
        var idx = 0
        for (n, a) in currentList!.affirmations.enumerated() {
            if a.affitmText == affirm.affitmText {
                idx = n
            }
        }
        do {
            try realm.write {
                currentList?.affirmations.remove(at: idx)
            }
        } catch {
            print("Error while delete affirm from list")
        }
    }
    
//    func saveList(list : AffirmationsList) {
//        if let _ = currentList {
//            do {
//                try realm.write {
//                    print("write")
//                    print(currentList)
//                    print(list)
//                    currentList!.affirmations.removeAll()
//                    currentList!.affirmations.insert(contentsOf: list, at: 0)
//                    print(currentList)
//
//                }
//            } catch {
//                print(error)
//            }
//        } else {
//            do {
//                try realm.write {
//                    realm.add(list)
//                }
//            } catch {
//                print()
//            }
//        }
//        print("save")
//    }
    
    //MARK: - Buttons
    
    
    @IBAction func doneButtonTaped(_ sender: Any) {
        if let vc = lastVC {
            vc.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
//            let viewController = UIApplication.shared.windows.first!.rootViewController as! AffirmationsPLCollectionVC
            //let viewController = self.navigationController?.viewControllers[0] as! AffirmationsPLCollectionVC
            let navigationController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
            let firstVC = navigationController.viewControllers[0] as! AffirmationsPLCollectionVC
            firstVC.collectionView.reloadData()
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
//        if let list = currentList {
//            let listAf = List<Affirmation>()
//            listAf.insert(contentsOf: affirmations.values, at: 0)
//            list.affirmations = listAf
//            saveList(list: list)
//            print(listAf)
//        } else {
//            print("tap")
//            let newList = AffirmationsList()
//            newList.name = listName!
//            newList.affirmations.insert(contentsOf: affirmations.values, at: 0)
//            saveList(list: newList)
//            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
//        }
        //self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
