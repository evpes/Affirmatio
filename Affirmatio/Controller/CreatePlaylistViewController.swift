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
    var curList: AffirmationsList?
    var lastVC: AffirmationsPLCollectionVC?
    var isEdit: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        if let list = curList {
            textField.text = list.name
        }
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
    
    func updateList() {
        print(curList)
        do {
            try realm.write {
                if let list = curList {
                    list.name = textField.text!
                    print("curList inside:\(curList)")
                    print("list inside:\(list)")
                }
            }
        } catch {
            print("Error while updating list:\(error)")
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

extension CreatePlaylistViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //text field when click done
 
        if textField.text!.count > 0 {
            if let _ = isEdit {
                updateList()
                self.dismiss(animated: true) {
                    if let vc = self.lastVC {
                        vc.editIndexPath = nil
                        vc.editList = nil
                        vc.collectionView.reloadData()
                    }
                }
            } else {
            createList(name: textField.text!)
            performSegue(withIdentifier: "goToAffirmCategories", sender: self)
            }
        }
        return true
    }
    
}
