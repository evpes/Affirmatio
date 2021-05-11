//
//  AffirmationsCategoriesViewController.swift
//  Affirmatio
//
//  Created by evpes on 08.05.2021.
//

import UIKit
import RealmSwift

class AffirmationsCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
        
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    @IBOutlet weak var tableView: UITableView!
    var lastVC: UITableView?
    var categories: Results<AffirmationsCategory>?
    //var affirmations: [String : Affirmation] = [:]
    var currentList: AffirmationsList?
    var listName: String?
    let realm = try! Realm()
    var expandArray : [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadCategories()
        if let cat = categories {
            for _ in cat {
                expandArray.append(false)
            }
        }
        tableView.register(CategoryHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        let bgView = UIView()
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
    
    self.tableView.backgroundView = bgView
    bgView.layer.addSublayer(gradient)
        animateGradient()

        
        

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
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories?[section].name
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("expand array did select row:\(expandArray)")
        if let cat = categories {
            if let cell = tableView.cellForRow(at: indexPath) {
                
                if indexPath.row == cat[indexPath.section].affirmations.count {
                    performSegue(withIdentifier: "goToNewAffirm2", sender: self)
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
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
//            cell.textLabel?.textColor = .white
//            cell.textLabel?.shadowOffset = CGSize(width: 1.0, height: 1.0)
//            cell.textLabel?.shadowColor = .black
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! CategoryHeaderView
        
        view.textLabel?.textColor = .white
        view.textLabel?.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.textLabel?.shadowColor = .black
        
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
        view.image.image = UIImage(named: "work\(section + 2).jpg")
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
        
        //let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        //overlay.backgroundColor = UIColor.gray
        //view.image.addSubview(overlay)
        
        
        return view
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
    
    func animateGradient() {
            if currentGradient < gradientSet.count - 1 {
                currentGradient += 1
            } else {
                currentGradient = 0
            }
            
            let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
            gradientChangeAnimation.duration = 5.0
            gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
            gradientChangeAnimation.isRemovedOnCompletion = false
            gradient.add(gradientChangeAnimation, forKey: "colorChange")
        }

    
    @objc func handleExpandClose(button: UIButton) {
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
            tableView.reloadData()
        } else {
            print("!isExp")
            tableView.insertRows(at: indexPaths, with: .fade)
            headerView.button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
            tableView.reloadData()
        }
        
    }
    
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
            vc.reloadData()
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
            if segue.identifier == "goToNewAffirm2" {
                let vc = segue.destination as! NewAffirmationViewController
                vc.category = categories?[indexPath[0].section]
                vc.categoriesVC = self
            }
            
        }
    }

}

extension AffirmationsCategoriesViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
