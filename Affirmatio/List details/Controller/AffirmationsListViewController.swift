//
//  AffirmationsListViewController.swift
//  Affirmatio
//
//  Created by evpes on 08.05.2021.
//

import UIKit
import RealmSwift

class AffirmationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //let realm = try! Realm()
    let iapManager = IAPManager.shared
    let notificationCenter = NotificationCenter.default
    let dataManager = DataManager()
    
    var affirmsList : AffirmationsList?
    var bgView: GradientBackground?
    
    @IBOutlet weak var playAffirmationsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView = GradientBackground(frame: self.view.bounds)
        self.tableView.backgroundView = bgView
        notificationCenter.addObserver(self, selector: #selector(checkPremium), name: NSNotification.Name(IAPProduct.premiumSubscription.rawValue), object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        checkPremium()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func checkPremium() {
        print("check premium is active ALVC \(iapManager.subscriptionIsActive())")
        if !iapManager.subscriptionIsActive() {
            playAffirmationsButton.tintColor = .gray
        } else {
            playAffirmationsButton.tintColor = .systemGreen
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if let list = affirmsList {
            print(list)
            return list.affirmations.count + 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! AffirmViewCell
        
        if let list = affirmsList {
            if indexPath.row > list.affirmations.count - 1 {
                cell.affirmLabel?.text = NSLocalizedString(" + add affirmations", comment: "")
                cell.affirmLabel?.textColor = .gray
            } else {
                cell.affirmLabel?.text = list.affirmations[indexPath.row].affitmText
                cell.affirmLabel?.textColor = .white
            }
        } else {
            cell.affirmLabel?.text = NSLocalizedString(" + add affirmations", comment: "") 
            cell.affirmLabel?.textColor = .gray
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    //     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        if editingStyle == .delete {
    //            // Delete the row from the data source
    //            dataManager.deleteAffirm(at: indexPath, from: affirmsList)
    //            //deleteAffirm(path: indexPath)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //
    //    }
    //
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //
    //        if let list = affirmsList {
    //        if list.affirmations.count == indexPath.row {
    //            return UITableViewCell.EditingStyle.none
    //        } else {
    //            return UITableViewCell.EditingStyle.delete
    //        }
    //        }
    //        return UITableViewCell.EditingStyle.none
    //    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .destructive, title: "", handler: { (action,view,completionHandler ) in
            if let list = self.affirmsList {
                if list.affirmations.count == indexPath.row {
                    return
                } else {
                    self.dataManager.deleteAffirm(at: indexPath, from: self.affirmsList)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            completionHandler(true)
        })
        action.image = UIImage(systemName: "trash.circle")
        action.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == affirmsList?.affirmations.count {
            performSegue(withIdentifier: "fromListToCategories", sender: self)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playList" {
            let vc = segue.destination as! PlayListViewController
            vc.affrirmations = affirmsList?.affirmations
        }
        
        if segue.identifier == "fromListToCategories" {
            let vc = segue.destination as! AffirmationsCategoriesViewController
            vc.currentList = affirmsList
            vc.lastVC = self.tableView
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    
    // MARK: - Data manipilation methods
    
    
    
    @IBAction func playList(_ sender: Any) {
        guard let list = affirmsList else {
            return
        }
        
        if !iapManager.subscriptionIsActive() {
            performSegue(withIdentifier: "fromListToSubscriptions", sender: self)
            return
        }
        
        if list.affirmations.count > 0 {
            performSegue(withIdentifier: "playList", sender: self)
        }
        
    }
    
    
}


