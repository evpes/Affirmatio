//
//  CreatePlaylistViewController.swift
//  Affirmatio
//
//  Created by evpes on 24.04.2021.
//

import UIKit
import RealmSwift

class CreatePlaylistViewController: UIViewController {

    let realm = try! Realm()
    @IBOutlet weak var textField: UITextField!
    var newList: AffirmationsList?
    var lastVC: UITableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAffirmCategories" {
            let vc = segue.destination as! AffirmCategoriesViewController
            vc.listName = textField.text
            vc.currentList = newList
            
        }
    }
    
    func createList(name: String) {
        let list = AffirmationsList()
        list.name = name
        do {
            try realm.write {
                realm.add(list)
            }
        } catch {
            print("Error while creating list:\(error)")
        }
        newList = list
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

extension CreatePlaylistViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //text field when click done
        if textField.text!.count > 0 {
            createList(name: textField.text!)
            performSegue(withIdentifier: "goToAffirmCategories", sender: self)
        }
        return true
    }
    
}
