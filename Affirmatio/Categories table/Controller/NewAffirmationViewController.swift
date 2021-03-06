//
//  NewAffirmationViewController.swift
//  Affirmatio
//
//  Created by evpes on 04.05.2021.
//

import UIKit
import RealmSwift

class NewAffirmationViewController: UIViewController {
    
    //@IBOutlet weak var textField: UITextField!
    var category: AffirmationsCategory?
    var categoriesVC: AffirmationsCategoriesViewController?
    //@IBOutlet weak var bgView: UIView!
    var bgView : GradientBackground?
    var editAffirmIndex : IndexPath?
    @IBOutlet weak var howToButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    
    let dataManager = DataManager()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        textField.delegate = self
//        textField.becomeFirstResponder()
//        textField.alpha = 0.7
        
        textView.delegate = self
        textView.becomeFirstResponder()
        textView.alpha = 0.7
        textView.layer.cornerRadius = 15
        textView.textContainer.heightTracksTextView = true
        
        textView.text = "Affirmation text"
        textView.textColor = UIColor.lightGray
        
        howToButton.layer.cornerRadius = 15
        howToButton.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        howToButton.titleLabel?.tintColor = .black
    
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
        
        //print("index = \(editAffirmIndex)")
        if let index = editAffirmIndex {
            
            //print("affirmText = \(category?.affirmations[index.row].affitmText)")
            textView.text = category?.affirmations[index.row].affitmText
        }
        
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
    }
    
    @IBAction func howToButtonPressed(_ sender: UIButton) {
        
    }
    
    

}

//extension NewAffirmationViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField.text?.count == 0 {
//            textField.placeholder = NSLocalizedString("You need enter affirm text to add new affirmation to category", comment: "")
//            return false
//        }
//        if let cat = categoriesVC {
//            if let index = editAffirmIndex {
//                guard let editCategory = category else {
//                    return false
//                }
//                do {
//                    try realm.write {
//                        editCategory.affirmations[index.row].affitmText = textField.text!
//                        //editCategory.affirmations[index.row].soundPath = audioPath
//                    }
//                } catch {
//                    print("Error while delete affirm from category: \(error)")
//                }
//            } else {
//                dataManager.addAffirm(to: category!,with: textView.text!)
//            }
//            cat.tableView.reloadData()
//            self.dismiss(animated: true, completion: nil)
//        }
//        return true
//    }
//}

extension NewAffirmationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            
            if textView.text.count == 0 {
                textView.text = NSLocalizedString("You need enter affirm text to add new affirmation to category", comment: "")
                textView.textColor = UIColor.lightGray
                return false
            }
            
            if let cat = categoriesVC {
                if let index = editAffirmIndex {
                    guard let editCategory = category else {
                        return false
                    }
                    do {
                        try realm.write {
                            editCategory.affirmations[index.row].affitmText = textView.text!
                            //editCategory.affirmations[index.row].soundPath = audioPath
                        }
                    } catch {
                        print("Error while delete affirm from category: \(error)")
                    }
                } else {
                    dataManager.addAffirm(to: category!,with: textView.text!)
                }
                cat.tableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}


