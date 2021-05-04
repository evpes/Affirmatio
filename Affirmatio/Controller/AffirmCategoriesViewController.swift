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
            let res = (categories?[section].affirmations.count ?? 0) + 1
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
                
                if indexPath.row == cat[indexPath.section].affirmations.count {
                    performSegue(withIdentifier: "goToNewAffirm", sender: self)
                } else {
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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        if let cat = categories {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            if indexPath.row == cat[indexPath.section].affirmations.count
            {
                cell.textLabel?.text = " + add new affirmation"
                cell.textLabel?.textColor = .gray
                cell.textLabel?.alpha = 0.6
            } else {
                cell.textLabel?.textColor = .black
                cell.textLabel?.alpha = 1
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
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! CategoryHeaderView
        view.button.tag = section
        view.button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        view.image.image = UIImage(named: "work\(section).jpg")
        view.tintColor = .clear
        
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

    
    @objc func handleExpandClose(button: UIButton) {
        print("Try close section")
        let section = button.tag
        let headerView = tableView.headerView(forSection: section) as! CategoryHeaderView
        var indexPaths : [IndexPath] = []
        
        
        if let cat = categories {
            let range = cat[section].affirmations.indices
            let newRange = range.startIndex..<(range.endIndex + 1)
            print(newRange)
            for row in newRange{
                
                let indexPath = IndexPath(row: row, section: section)
                indexPaths.append(indexPath)
            }
        }
        
        let isExpanded = expandArray[section]
        expandArray[section] = !isExpanded
        print("categories: \(categories)")
        
        if isExpanded {
            print("isExp")
            tableView.deleteRows(at: indexPaths, with: .fade)
            
            headerView.button.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
            //tableView.reloadData()
        } else {
            print("!isExp")
            tableView.insertRows(at: indexPaths, with: .fade)
            headerView.button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            
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

    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //      Get the new view controller using segue.destination.
        //      Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathsForSelectedRows {
            if segue.identifier == "goToNewAffirm" {
                let vc = segue.destination as! NewAffirmationViewController
                vc.category = categories?[indexPath[0].section]
                vc.categoriesVC = self
            }
            
        }
    }
    
    
}
