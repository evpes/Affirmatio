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
    
    //background gradient setup
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    let realm = try! Realm()
    
    let itemsPerRow: CGFloat = 2
    let sectionsInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var playlists: [String] = ["Family", "Money"]
    var affirmLists: Results<AffirmationsList>?
    var editList: Bool?
    var editIndexPath: IndexPath?
    
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
            
            let categories = ["Money","Love & Relationships","Self","Health","Happiness"]
            
            for c in categories {
                let newCategory = AffirmationsCategory()
                newCategory.name = c
                saveCategories(category: newCategory)
            }
            
            let categoriesObj = realm.objects(AffirmationsCategory.self)
            let affimationsText =
                [
                    ["Money comes to me easily and effortlessly",
                     "I constantly attract opportunities that create more money.",
                     "I am worthy of making more money.",
                     "I am open and receptive to all the wealth life offers me.",
                     "My actions create constant prosperity.",
                     "Money and spirituality can co-exist in harmony."
                    ],
                    [ "I am full of positive loving energy.",
                      "I welcome love and romance into my life.",
                      "I am in a loving and supportive relationship.",
                      "I deserve love and I get it in abundance.",
                      "I am loved, loving and lovable.",
                      "I am blessed with an incredible family and wonderful friends.",
                      "I give out love and it is returned to me multiplied manyfold."
                    ],
                    [
                        "I forgive myself and set myself free.",
                        "I believe I can be all that I want to be.",
                        "I am in the process of becoming the best version of myself",
                        "I have the freedom & power to create the life I desire.",
                        "I choose to be kind to myself and love myself unconditionally.",
                        "My possibilities are endless.",
                        "I am worthy of my dreams.",
                        "I am enough."
                    ],
                    [
                        "I deserve to be healthy and feel good.",
                        "I am full of energy and vitality and my mind is calm and peaceful.",
                        "Every day I am getting healthier and stronger.",
                        "I honor my body by trusting the signals that it sends me.",
                        "I manifest perfect health by making smart choices."
                    ],
                    [
                        "I am grateful to be alive. It is my joy and pleasure to live another wonderful day.",
                        "Happiness is my birthright. I choose to be happy and I deserve to be happy.",
                        "Being happy comes easy to me. Happiness is my second nature.",
                        "Good things are happening.",
                        "I am deeply fulfilled by what I do."
                    ]
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bgView = UIView()
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])
        
        
        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        
        self.collectionView.backgroundView = bgView
        bgView.layer.addSublayer(gradient)
        animateGradient()
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(sender)
        if segue.identifier == "showDetail2List" {
            let vc = segue.destination as! AffirmationsListViewController//ListAffirmsViewController
            if let indexPath = collectionView.indexPathsForSelectedItems {
                vc.affirmsList = affirmLists?[indexPath[0].row]
            }
        }
        if segue.identifier == "createPlaylist" {
            if let edit = editList {
                if edit {
                    let vc = segue.destination as! CreatePlaylistViewController
                    vc.lastVC = self
                    vc.isEdit = true
                    if let indexPath = editIndexPath {
                        vc.curList = affirmLists?[indexPath.row]
                    }
                }
            }
            
            //
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
                cell.alpha = 0.5
            } else {
                if let lists = affirmLists {
                    cell.affirmPLLabel.text = lists[indexPath.row].name
                    cell.affirmPLLabel.alpha = 1
                    cell.alpha = 1
                    cell.affirmPLLabel.textColor = .black
                    cell.affirmPLImageView.image = UIImage(named: lists[indexPath.row].picture)
                }
            }
            
        }
        cell.affirmPLImageView.contentMode = .scaleAspectFill
        cell.affirmPLImageView.layer.masksToBounds = true
        
        cell.affirmPLLabel.textColor = .white
        cell.affirmPLLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.affirmPLLabel.shadowColor = .black
        
        cell.backgroundColor = .clear
        
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
                performSegue(withIdentifier: "showDetail2List", sender: self)
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
                        print("deleting")
                        self.deleteList(list: list[indexPath.row])
                        self.collectionView.reloadData()
                    }
                    
                    let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { (action) in
                        print("edit")
                        self.editList = true
                        self.editIndexPath = indexPath
                        self.performSegue(withIdentifier: "createPlaylist", sender: self)
                    }
                    // Create other actions...
                    
                    return UIMenu(title: "", children: [delete,edit])
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
    
    //MARK:- Gradient func
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

extension AffirmationsPLCollectionVC: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
}

