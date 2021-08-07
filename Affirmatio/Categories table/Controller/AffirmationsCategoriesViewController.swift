//
//  AffirmationsCategoriesViewController.swift
//  Affirmatio
//
//  Created by evpes on 08.05.2021.
//

import UIKit
import RealmSwift

class AffirmationsCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    var bgView: GradientBackground?
    var lastVC: UITableView?
    var categories: Results<AffirmationsCategory>?
    var currentList: AffirmationsList?
    var listName: String?
    var expandArray : [Bool] = []
    var editAffirmIndex : IndexPath?
    
    let notificationCenter = NotificationCenter.default
    let realm = try! Realm()
    let iapManager = IAPManager.shared
    let dataManager = DataManager()
                
    override func viewDidLoad() {
        notificationCenter.addObserver(self, selector: #selector(reload), name: NSNotification.Name(IAPProduct.premiumSubscription.rawValue), object: nil)
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        categories = dataManager.loadCategories()
        if let cat = categories {
            for _ in cat {
                expandArray.append(false)
            }
        }
        tableView.register(CategoryHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
    
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
        tableView.backgroundColor = .clear
        print("did load \(Date())")
        //self.tableView.backgroundView = bgView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bgView?.animateGradient()
        print("did appear \(Date())")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories?.count ?? 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    
    @objc func reload() {
        tableView.reloadData()
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("expand array did select row:\(expandArray)")
        if let cat = categories {
            if let cell = tableView.cellForRow(at: indexPath) as? AffirmationCatViewCell {
                
                if indexPath.row == cat[indexPath.section].affirmations.count {
                    if iapManager.subscriptionIsActive() {
                        performSegue(withIdentifier: "goToNewAffirm2", sender: self)
                    } else {
                        performSegue(withIdentifier: "fromCategoriesToSubscriptions", sender: self)
                    }
                } else {
                    if !cell.check {
                        print("none")
                        cell.check = true
                        let affirmation = cat[indexPath.section].affirmations[indexPath.row]
                        dataManager.addAffirm(affirmation, to: currentList)
                        //appendAffirm(affirm: affirmation)
                        tableView.reloadData()
                    } else {
                        let affirmation = cat[indexPath.section].affirmations[indexPath.row]
                        cell.check = false
                        dataManager.deleteAffirm(affirmation, from: currentList)
                        //deleteAffirm(affirm: affirmation)
                        tableView.reloadData()
                    }
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! AffirmationCatViewCell
        
        
        //previous implemintation
        if let cat = categories {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            if indexPath.row == cat[indexPath.section].affirmations.count
            {
                cell.affirmLabel?.text = NSLocalizedString(" + add new affirmation", comment: "")
                cell.affirmLabel?.textColor = .gray
                cell.checkmarkView.image = UIImage()
                //cell.affirmLabel?.alpha = 0.6
            } else {
                cell.affirmLabel?.textColor = .white
                //cell.affirmLabel?.alpha = 1
                print("sec \(indexPath.section) row \(indexPath.row)")
                let text = cat[indexPath.section].affirmations[indexPath.row].affitmText
                cell.affirmLabel?.text = text
                //.filter("check == %@", false)
                //print(currentList)
                let array = Array(currentList!.affirmations)
                print(array)
                cell.checkmarkView.image = UIImage(systemName: "circle")
                if  currentList!.affirmations.filter("affitmText = %@", text).count > 0 {
                    cell.check = true
                    cell.checkmarkView.image = UIImage(systemName: "dot.circle.fill")
                } else {
                    cell.check = false
                    cell.checkmarkView.image = UIImage(systemName: "circle")                }
            }
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        print("return cell at \(indexPath) date \(Date())")
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! CategoryHeaderView
        guard let category = categories?[section] else {
            print("category with section \(section) not found")
            return view
        }
        
        view.textLabel?.textColor = .white
        view.textLabel?.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.textLabel?.shadowColor = .black
        
        view.title.text = category.name
        view.title.textColor = .white
        view.title.shadowOffset = CGSize(width: 2, height: 2)
        view.title.shadowColor = .black
        view.title.font = UIFont.boldSystemFont(ofSize: 26)
        
        view.button.imageView?.contentMode = .scaleAspectFit
        view.button.contentHorizontalAlignment = .fill
        view.button.contentVerticalAlignment =  .fill
        view.button.imageView?.tintColor = .white
        view.button.imageView?.layer.shadowColor = UIColor.black.cgColor
        view.button.imageView?.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.button.imageView?.layer.shadowOpacity = 0.5
        view.button.imageView?.layer.masksToBounds = false
        
        view.button.tag = section
        view.button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        view.image.image = UIImage(named:  "\(category.name).jpg")
        //print(categories?[section].name)
        view.tintColor = .clear
        print("view for header in section:\(section)")
        
        let isExpanded = expandArray[section]
        print("expand array before:\(expandArray)")
        //expandArray[section] = !isExpanded
        //print("categories: \(categories)")
        print("expand array after:\(expandArray)")
        
        if isExpanded {
            print("isExp")
            //view.deleteRows(at: indexPaths, with: .fade)
            
            view.button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            //tableView.reloadData()
        } else {
            print("!isExp")
            //view.insertRows(at: indexPaths, with: .fade)
            view.button.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
        }
        
       view.button.isSelected = true // not blocked category
        if Affirmations.premiumCategories.contains(category.name) && !iapManager.subscriptionIsActive() {
            view.button.setImage(UIImage(systemName: "lock.circle"), for: .normal)
            view.button.isSelected = false // blocked category
        }
        
        //let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        //overlay.backgroundColor = UIColor.gray
        //view.image.addSubview(overlay)
        print("return header at section \(section) date \(Date())")
        
        return view
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if let category = self.categories?[indexPath.section] {
            if indexPath.row == category.affirmations.count {
                return UISwipeActionsConfiguration()
            } else {
                let delete =  UIContextualAction(style: .destructive, title: "", handler: { (action,view,completionHandler ) in
                    if let category = self.categories?[indexPath.section] {
                        self.dataManager.deleteAffirm(at: indexPath.row, from: category)
                        tableView.deleteRows(at: [indexPath], with: .fade)                        
                    }
                    
                    completionHandler(true)
                })
                delete.image = UIImage(systemName: "trash.circle")
                delete.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
                
                let edit = UIContextualAction(style: .normal, title: "") { acton, view, completionHandler in
                    if let _ = self.categories?[indexPath.section] {
                        self.editAffirmIndex = indexPath
                        self.performSegue(withIdentifier: "goToNewAffirm2", sender: self)
                    }
                }
                
                edit.image = UIImage(systemName: "pencil.circle")
                edit.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
                let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
                
                return configuration
            }
        }
        return UISwipeActionsConfiguration()
    }

    
    @objc func handleExpandClose(button: UIButton) {
        if !button.isSelected { //blocked category
            performSegue(withIdentifier: "fromCategoriesToSubscriptions", sender: self)
            
        } else {
        print("Try close section")
        let section = button.tag
        let headerView = tableView.headerView(forSection: section) as! CategoryHeaderView
        var indexPaths : [IndexPath] = []
        print("handleExpandClose section:\(section)")
        
        
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
        print("expand array before:\(expandArray)")
        expandArray[section] = !isExpanded
        //print("categories: \(categories)")
        print("expand array after:\(expandArray)")
        
        if isExpanded {
            print("isExp")
            tableView.deleteRows(at: indexPaths, with: .fade)
            
            headerView.button.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                //self.tableView.reloadData()
            }
        } else {
            print("!isExp")
            tableView.insertRows(at: indexPaths, with: .fade)
            headerView.button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                //self.tableView.reloadData()
            }
            
        }
        }
    }
    
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    
    
    
    //MARK: - Buttons
    
    
    @IBAction func doneButtonTaped(_ sender: Any) {
        if let vc = lastVC {
            vc.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
            //            let viewController = UIApplication.shared.windows.first!.rootViewController as! AffirmationsPLCollectionVC
            //let viewController = self.navigationController?.viewControllers[0] as! AffirmationsPLCollectionVC
            let navigationController = UIApplication.shared.windows[0].rootViewController as! UINavigationController
            let firstVC = navigationController.viewControllers[0] as! AffirmationsPLCollectionVC
            firstVC.collectionView.reloadData()
            firstVC.syncWidgetAppAffirms()
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }

    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //      Get the new view controller using segue.destination.
        //      Pass the selected object to the new view controller.
        print("prepare1")
        if segue.identifier == "goToNewAffirm2" {
            let vc = segue.destination as! NewAffirmationViewController
        if let indexPath = tableView.indexPathsForSelectedRows {
                vc.category = categories?[indexPath[0].section]
                vc.categoriesVC = self
        }
        if let editIndexPath = editAffirmIndex {
                print("prepare3")
                vc.category = categories?[editIndexPath.section]
                vc.categoriesVC = self
                //print("editAffirmIndex = \(editAffirmIndex)")
            vc.editAffirmIndex = editIndexPath
            editAffirmIndex = nil
        }
    }

}
}

