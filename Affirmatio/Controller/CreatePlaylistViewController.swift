//
//  CreatePlaylistViewController.swift
//  Affirmatio
//
//  Created by evpes on 24.04.2021.
//

import UIKit
import RealmSwift

class CreatePlaylistViewController: UIViewController {

    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    var pictureName = "nature\(Int.random(in: 1...13))"
        
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    let realm = try! Realm()
    @IBOutlet weak var textField: UITextField!
    var newList: AffirmationsList?
    var curList: AffirmationsList?
    var lastVC: AffirmationsPLCollectionVC?
    var isEdit: Bool?
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        if let list = curList {
            textField.text = list.name
        }
        if let _ = isEdit {
            listImage.image = UIImage(named: curList!.picture)
        } else {
            listImage.image = UIImage(named: pictureName)
        }
        
        listImage.clipsToBounds = true
        listImage.layer.cornerRadius = 15
        imageContainerView.layer.cornerRadius = 15
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageContainerView.layer.shadowOpacity = 0.7
        
//        cell.affirmImageView.image = UIImage(named: "nature\(indexPath.row + 1)")
//        cell.affirmView.layer.cornerRadius = cornerRadius
//        cell.affirmView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        cell.affirmView.layer.shadowColor = UIColor.darkGray.cgColor
//        cell.affirmView.layer.shadowOpacity = 0.7
//        cell.affirmImageView.layer.cornerRadius = cornerRadius
//        cell.affirmImageView.clipsToBounds = true
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAffirmCategories2" {
            let vc = segue.destination as! AffirmationsCategoriesViewController
            vc.listName = textField.text
            vc.currentList = newList
        }
        if segue.identifier == "chooseListImage" {
            let vc = segue.destination as! ListImageSelectionViewController
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
        print(curList)
        do {
            try realm.write {
                if let list = curList {
                    list.picture = pictureName
                    list.name = textField.text!
                    print("curList inside:\(curList)")
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
            performSegue(withIdentifier: "goToAffirmCategories2", sender: self)
            }
        }
        return true
    }
    
}

extension CreatePlaylistViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}
