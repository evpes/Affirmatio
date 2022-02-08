//
//  CreatePlaylistViewController.swift
//  Affirmatio
//
//  Created by evpes on 24.04.2021.
//

import UIKit
import RealmSwift

class CreatePlaylistViewController: UIViewController {

    var pictureName = "list_image\(Int.random(in: 1...31))"
        
    let realm = try! Realm()
    @IBOutlet weak var textField: UITextField!
    var newList: AffirmationsList?
    var curList: AffirmationsList?
    var lastVC: AffirmationsPLCollectionVC?
    var isEdit: Bool?
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var editButtonOutlet: UIButton!
    var bgView: GradientBackground?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        
        if let list = curList {
            textField.text = list.name
        }
        if let _ = isEdit {
            listImage.image = UIImage(named: curList!.picture)
            pictureName = curList!.picture
        } else {
            listImage.image = UIImage(named: pictureName)
        }
        
        listImage.clipsToBounds = true
        listImage.layer.cornerRadius = 15
        imageContainerView.layer.cornerRadius = 15
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageContainerView.layer.shadowOpacity = 0.7
        editButtonOutlet.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        editButtonOutlet.layer.cornerRadius = 15
        
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        bgView!.animateGradient()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAffirmCategories2" {
            let vc = segue.destination as! AffirmationsCategoriesViewController
            vc.listName = textField.text
            vc.currentList = newList
        }
        if segue.identifier == "chooseListImage" {
            let vc = segue.destination as! ListImageSelectionViewController
            vc.currentImage = pictureName
            vc.prevVC = self
        }
    }
    
    func createList(name: String) {
        let list = AffirmationsList()
        list.name = name
        list.picture = pictureName
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
//        print(curList)
        do {
            try realm.write {
                if let list = curList {
                    list.picture = pictureName
                    list.name = textField.text!
            //        print("curList inside:\(curList)")
                    print("list inside:\(list)")
                }
            }
        } catch {
            print("Error while updating list:\(error)")
        }
    }
    
    @IBAction func editImageButtonPressed(_ sender: Any) {
        print("edit")
        performSegue(withIdentifier: "chooseListImage", sender: self)
    }
    

}

extension CreatePlaylistViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //text field when click done
 
        if textField.text!.count > 0 {
            if let _ = isEdit {
                updateList()
                self.dismiss(animated: true) {
                    if let vc = self.lastVC {
                        vc.selectedIndexPath = nil
                        vc.editList = nil
                        
                        vc.loadData()
                        vc.reloadPersonalLists()
                        vc.reloadData()
                    }
                }
            } else {
            createList(name: textField.text!)
                if let vc = self.lastVC {                    
                    //vc.collectionView.reloadData()
                    vc.loadData()
                    print("data loaded")
                    vc.reloadPersonalLists()
                    print("sections and items loaded")
                    vc.reloadData()
                    print("data reloaded")
                    
                }
            performSegue(withIdentifier: "goToAffirmCategories2", sender: self)
            }
        }
        return true
    }
    
}

