//
//  AffirmationsListViewController.swift
//  Affirmatio
//
//  Created by evpes on 08.05.2021.
//

import UIKit
import RealmSwift

class AffirmationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    
    var affirmsList : AffirmationsList?
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
        
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
        return 80
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! AffirmViewCell
        cell.affirmView.layer.cornerRadius = 13
        cell.affirmView.backgroundColor = .black
        cell.affirmView.alpha = 0.2
        cell.backgroundColor = .clear
        
        
        if let list = affirmsList {
            if indexPath.row > list.affirmations.count - 1 {
                cell.affirmLabel?.text = " + add affirmations"
                cell.affirmLabel?.textColor = .gray
            } else {
            cell.affirmLabel?.text = list.affirmations[indexPath.row].affitmText
                cell.affirmLabel?.textColor = .white
            }
        } else {
            cell.affirmLabel?.text = " + add affirmations"
            cell.affirmLabel?.textColor = .gray
        }
        
        cell.affirmLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.affirmLabel.shadowColor = .black
        cell.selectionStyle = .none

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
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            print("delete")
            deleteAffirm(path: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
    
    //MARK:- Gradient func
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
    
    @IBAction func playList(_ sender: Any) {
        performSegue(withIdentifier: "playList", sender: self)
    }
    

}

extension AffirmationsListViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
