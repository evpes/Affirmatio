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
    var editAffirmIndex : IndexPath?
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
        
        print("index = \(editAffirmIndex)")
        if let index = editAffirmIndex {
            guard let curCategory = category else {
                print("Category does not send")
                return
            }
            print("affirmText = \(category?.affirmations[index.row].affitmText)")
            textField.text = category?.affirmations[index.row].affitmText
        }
        
 
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
            textField.placeholder = NSLocalizedString("You need enter affirm text to add new affirmation to category", comment: "")
            return false
        }
        if let cat = categoriesVC {
            if let index = editAffirmIndex {
                guard let editCategory = category else {
                    return false
                }
                do {
                    try realm.write {
                        editCategory.affirmations[index.row].affitmText = textField.text!
                    }
                } catch {
                    print("Error while delete affirm from category: \(error)")
                }
            } else {
                dataManager.addAffirm(to: category!,with: textField.text!)
            }
            cat.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }
}

