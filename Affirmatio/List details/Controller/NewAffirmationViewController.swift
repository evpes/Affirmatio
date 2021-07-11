//
//  NewAffirmationViewController.swift
//  Affirmatio
//
//  Created by evpes on 04.05.2021.
//

import UIKit
import RealmSwift

class NewAffirmationViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    var category: AffirmationsCategory?
    var categoriesVC: AffirmationsCategoriesViewController?
    //@IBOutlet weak var bgView: UIView!
    var bgView : GradientBackground?
    @IBOutlet weak var howToButton: UIButton!
    
    
    let dataManager = DataManager()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.alpha = 0.7
        
        howToButton.layer.cornerRadius = 15
        howToButton.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        howToButton.titleLabel?.tintColor = .black
    
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
        
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
    }
    
    @IBAction func howToButtonPressed(_ sender: UIButton) {
        
    }
    
    

}

extension NewAffirmationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.count == 0 {
            textField.placeholder = "You need enter affirm text to add new affirmation to category"
            return false
        }
        if let cat = categoriesVC {
            dataManager.addAffirm(to: category!,with: textField.text!)
            cat.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }
}


