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
    var categoriesVC: AffirmCategoriesViewController?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()

        // Do any additional setup after loading the view.
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
