//
//  NewAffirmationViewController.swift
//  Affirmatio
//
//  Created by evpes on 04.05.2021.
//

import UIKit
import RealmSwift

class NewAffirmationViewController: UIViewController {

    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
        
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    @IBOutlet weak var textField: UITextField!
    var category: AffirmationsCategory?
    var categoriesVC: AffirmationsCategoriesViewController?
    @IBOutlet weak var bgView: UIView!
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.alpha = 0.8
        
        //let bgView = UIView()
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
    
        //self.view.backgroundView = bgView
        self.view.layer.insertSublayer(gradient, at: 0)
        //bgView.layer.addSublayer(gradient)
        animateGradient()

        // Do any additional setup after loading the view.
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
    
    func addAffirm(category: AffirmationsCategory) {
        do {
            try realm.write {
                let newAffirm = Affirmation()
                newAffirm.affitmText = textField.text!
                category.affirmations.append(newAffirm)
            }
        } catch {
            print("Error while add neew affirmation to category: \(error)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewAffirmationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 {
            textField.placeholder = "You need enter affirm text to add new affirmation to category"
            return false
        }
        if let cat = categoriesVC {
            addAffirm(category: category!)
            cat.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }
}

extension NewAffirmationViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
