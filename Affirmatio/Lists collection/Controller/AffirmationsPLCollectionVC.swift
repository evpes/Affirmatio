//
//  AffirmationsPLCollectionVC.swift
//  Affirmatio
//
//  Created by evpes on 22.04.2021.
//

import UIKit
import RealmSwift
import StoreKit
import AVFoundation


private let reuseIdentifier = "Cell"


class AffirmationsPLCollectionVC: UICollectionViewController {
    
    //let productIds =
    
    let notificationCenter = NotificationCenter.default
    
    let realm = try! Realm()
    let dataManager = DataManager()
    let iapManager = IAPManager.shared
    
    let itemsPerRow: CGFloat = 2
    let sectionsInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var affirmLists: Results<AffirmationsList>?
    var editList: Bool?
    var editIndexPath: IndexPath?
    
    //let iapHelper = IAPHelper(productIds: Set(["com.apsterio.Affirmatio.premium","com.apsterio.Affirmatio.premium6m","com.apsterio.Affirmatio.premium12m"]))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iapManager.checkSubscriptionPeriod()


        notificationCenter.addObserver(self, selector: #selector(setPremium), name: NSNotification.Name(IAPProduct.premiumSubscription.rawValue), object: nil)
//        print("get user defaults \(UserDefaults.standard.bool(forKey: IAPProduct.premiumSubscription.rawValue))" )
//        print("exp date = \(UserDefaults.standard.string(forKey: "expDate"))")
//        print("null value from UD \(UserDefaults.standard.object(forKey: "kek"))")
//        print("null value from UD bool \(UserDefaults.standard.bool(forKey: "kek12"))")
        //UserDefaults.standard.set(purchase.subscriptionExpirationDate, forKey: "expDate")
        ///
//        iapHelper.requestProducts { bol, res in
//            print(res)
//        }
        ///temp
        
        if LandscapeManager.shared.isFirstLaunch {
            performSegue(withIdentifier: "toOnboarding", sender: nil)
            for c in Affirmations.categories {
                let newCategory = AffirmationsCategory()
                newCategory.name = c                
                dataManager.saveCategories(category: newCategory)
            }
            
            let categoriesObj = realm.objects(AffirmationsCategory.self)
            
            for (n,cat) in categoriesObj.enumerated() {
                for af in Affirmations.affimationsText[n] {
                    dataManager.addAffirmation(affirmationTxt: af, to: cat)
                }
            }
            LandscapeManager.shared.isFirstLaunch = true
        }
        
        //var widgetContents : [WidgetContent] = []
        
        affirmLists = dataManager.loadAffirmLists()
//        print("affirmLists: \(affirmLists)")
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
//        let firstRun = UserDefaults.standard.bool(forKey: "firstRun") as Bool
//        if !firstRun {
//
//
//            UserDefaults.standard.set(true, forKey: "firstRun")
//        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let bgView = GradientBackground(frame: self.view.bounds)
        self.collectionView.backgroundView = bgView
        bgView.animateGradient()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(sender)
        if segue.identifier == "showDetail2List" {
            let vc = segue.destination as! AffirmationsListViewController//ListAffirmsViewController
            if let indexPath = collectionView.indexPathsForSelectedItems {
                vc.affirmsList = affirmLists?[indexPath[0].row]
            }
        }
        if segue.identifier == "createPlaylist" {
            let vc = segue.destination as! CreatePlaylistViewController
            vc.lastVC = self
            if let edit = editList {
                if edit {
                    vc.isEdit = true
                    if let indexPath = editIndexPath {
                        vc.curList = affirmLists?[indexPath.row]
                    }
                }
            }
        }
        
    }
    
    //MARK: - campare widget affirms count with affirm in stored lists
    
    func syncWidgetAppAffirms() {
        let widgetAffirmsCnt = dataManager.readContents().count
        let listsAffirmsCnt = affirmLists?.reduce(0, { (res, list) -> Int in
            return res + list.affirmations.count
        }) ?? 0
        if widgetAffirmsCnt != listsAffirmsCnt {
            if let lists = affirmLists {
                var contents: [WidgetContent] = []
                for list in lists {
                    contents = list.affirmations.map() { af in
                        WidgetContent(affirmText: af.affitmText)
                    }
                    dataManager.writeContents(contents)
                }
            }
        }
    }
    

    
    @objc private func setPremium() {
        let premiumCategories = realm.objects(AffirmationsCategory.self).filter("premium = 1")
        if premiumCategories.count == 0 {
            for c in Affirmations.premiumCategories {
                let newCategory = AffirmationsCategory()
                newCategory.name = c
                newCategory.premium = 1
                dataManager.saveCategories(category: newCategory)
            }
            for (n,cat) in premiumCategories.enumerated() {
                for af in Affirmations.premiumAffimationsText[n] {
                    dataManager.addAffirmation(affirmationTxt: af, to: cat)
                }
            }
        }
    }
    
    // MARK :- Buttons
    
    @IBAction func notificationsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toNotifications", sender: self)
        print("press")
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let lists = affirmLists {
            //print("lists \(lists)")
            return lists.count + 1
        }
        return  1
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "affirmPLCell", for: indexPath) as! AffirmationsPLCell
        if let lists = affirmLists {
            if indexPath.row == lists.count {
                cell.affirmPLLabel.text = NSLocalizedString("+ add new list", comment: "") 
                cell.affirmPLLabel.alpha = 0.3
                cell.alpha = 0.5
                cell.affirmPLImageView.image = UIImage()
                cell.affirmPLImageView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            } else {
                if let lists = affirmLists {
                    cell.affirmPLLabel.text = lists[indexPath.row].name
                    cell.affirmPLLabel.alpha = 1
                    cell.alpha = 1
                    cell.affirmPLLabel.textColor = .black
                    cell.affirmPLImageView.image = UIImage(named: lists[indexPath.row].picture)
                    cell.affirmPLImageView.backgroundColor = .clear
                    cell.backgroundColor = .clear
                }
            }
            
        }
        //cell.affirmPLLabel.textColor = .white
        cell.affirmPLLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //cell.affirmPLLabel.shadowColor = .black
        cell.affirmPLImageView.contentMode = .scaleAspectFill
        cell.affirmPLImageView.layer.masksToBounds = true
        
        cell.affirmPLLabel.textColor = .white
        cell.affirmPLLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cell.affirmPLLabel.shadowColor = .black
        
        cell.backgroundColor = .clear
        
        //configure the cell
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.6
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath)
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
        UIView.animate(withDuration: 0.3) {
            if let cell = collectionView.cellForItem(at: indexPath) as? AffirmationsPLCell {
                cell.affirmPLImageView.transform = .init(scaleX: 0.99, y: 0.99)
                cell.contentView.backgroundColor = .clear//UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
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
                        self.dataManager.deleteList(list: list[indexPath.row])
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
    
    

    
}

extension AffirmationsPLCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionsInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        print("width \(widthPerItem)")
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



