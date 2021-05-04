//
//  AffirmationsPLCollectionVC.swift
//  Affirmatio
//
//  Created by evpes on 22.04.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"


class AffirmationsPLCollectionVC: UICollectionViewController {

    
    let realm = try! Realm()
    
    let itemsPerRow: CGFloat = 2
    let sectionsInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var playlists: [String] = ["Family", "Money"]
    var affirmLists: Results<AffirmationsList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAffirmLists()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        let firstRun = UserDefaults.standard.bool(forKey: "firstRun") as Bool
                if !firstRun {
                    
                    let categories = ["Love","Money","Work"]
                    
                    for c in categories {
                        let newCategory = AffirmationsCategory()
                        newCategory.name = c
                        saveCategories(category: newCategory)
                    }
                    
                    let categoriesObj = realm.objects(AffirmationsCategory.self)
                    let affimationsText = [
                    ["I love world and world loves me", "I Love my friends", "I love my patents"],
                        ["I do best myself to earn money","I have enough money to all my wishes"],
                        ["I work hard", "I am the best from my team", "I get this work done"]
                    ]
                    for (n,cat) in categoriesObj.enumerated() {
                        for af in affimationsText[n] {
                            addAffirmation(affirmationTxt: af, to: cat)
                        }
                    }
                    
                    print("kek")
                    UserDefaults.standard.set(true, forKey: "firstRun")
                }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailList" {
            let vc = segue.destination as! ListAffirmsViewController
            if let indexPath = collectionView.indexPathsForSelectedItems {
                vc.affirmsList = affirmLists?[indexPath[0].row]
            }
        }
        if segue.identifier == "createPlaylist" {
            let vc = segue.destination as! CreatePlaylistViewController
            //vc.lastVC = self
        }
            
            }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let lists = affirmLists {
            return lists.count + 1
        }
        return  1
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "affirmPLCell", for: indexPath) as! AffirmationsPLCell
        if let lists = affirmLists {
            if indexPath.row > lists.count - 1 {
                cell.affirmPLLabel.text = "+ add new list"
                cell.affirmPLLabel.alpha = 0.3
            } else {
                if let lists = affirmLists {
                    cell.affirmPLLabel.text = lists[indexPath.row].name
                    cell.affirmPLLabel.alpha = 1
                    cell.affirmPLLabel.textColor = .black
                }
        }
        
        }
        cell.backgroundColor = .gray
        
        //configure the cell
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true

        cell.layer.cornerRadius = 13
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if let lists = affirmLists {
            if indexPath.row == lists.count {
                performSegue(withIdentifier: "createPlaylist", sender: self)
            } else {
                performSegue(withIdentifier: "showDetailList", sender: self)
            }
        } else {
            performSegue(withIdentifier: "createPlaylist", sender: self)
        }
        
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? AffirmationsPLCell {
                cell.affirmPLImageView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? AffirmationsPLCell {
                cell.affirmPLImageView.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if let list = affirmLists {
            if indexPath.row < list.count {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in

                // Create an action for sharing
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { action in
                    print("deleteng")
                    self.deleteList(list: list[indexPath.row])
                    self.collectionView.reloadData()
                }

                // Create other actions...

                return UIMenu(title: "", children: [delete])
            }
            }
        }
        return nil
        }
    
    // MARK: - Data manipulation methods
    
    func loadAffirmLists() {
        affirmLists = realm.objects(AffirmationsList.self)
        print(affirmLists)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    //MARK:- Data manipulation methods
    
    func saveCategories(category: AffirmationsCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories context: \(error)")
        }
        
    }
    
    func addAffirmation(affirmationTxt: String,to category: AffirmationsCategory) {
        do {
            try self.realm.write {
                let newAffirm = Affirmation()
                newAffirm.affitmText = affirmationTxt
                category.affirmations.append(newAffirm)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteList(list: AffirmationsList) {
        do {
            try realm.write {
                realm.delete(list)
            }
        } catch {
            print("Error while deleteng list:\(error)")
        }
    }

}

extension AffirmationsPLCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionsInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInsets.left
    }
    
}

