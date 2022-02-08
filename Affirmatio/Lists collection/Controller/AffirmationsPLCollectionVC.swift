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
    
    var sections = [Section]()
    var itemsSection1 = [Item]()
    var itemsSection2 = [Item]()
    var itemsSection3 = [Item]()
    
    let notificationCenter = NotificationCenter.default
    
    let realm = try! Realm()
    let dataManager = DataManager()
    let iapManager = IAPManager.shared
    
    var settings: [String : Float] = [:]
    
    let itemsPerRow: CGFloat = 2
    let sectionsInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var affirmLists: Results<AffirmationsList>?
    var categories: Results<AffirmationsCategory>?

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

    
    var editList: Bool?
    var selectedIndexPath: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Settings.plist")
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        collectionView.register(MediumTableCell.self, forCellWithReuseIdentifier: MediumTableCell.reuseIdentifier)
        collectionView.register(SmallTableCell.self, forCellWithReuseIdentifier: SmallTableCell.reuseIdentifier)
        collectionView.register(FeaturedTableCell.self, forCellWithReuseIdentifier: FeaturedTableCell.reuseIdentifier)
        
        iapManager.checkSubscriptionPeriod()
        notificationCenter.addObserver(self, selector: #selector(setPremium), name: NSNotification.Name(IAPProduct.premiumSubscription.rawValue), object: nil)
        dataManager.checkSettingsUpToDate()
        settings = dataManager.loadSettings(from: path)
        checkFirstLauch()
        
        loadData()
        checkNewAffirms()
        loadSectionsAndItems()
        createDataSource()
        reloadData()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let bgView = GradientBackground(frame: self.view.bounds)
        self.collectionView.backgroundView = bgView
        bgView.animateGradient()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with item: Item, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: item)
        return cell
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch self.sections[indexPath.section].type {
            case "featuredTable":
                return self.configure(FeaturedTableCell.self, with: itemIdentifier, for: indexPath)
            case "smallTable":
                return self.configure(SmallTableCell.self, with: itemIdentifier, for: indexPath)
            default:
                return self.configure(MediumTableCell.self, with: itemIdentifier, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return nil
            }
            
            guard let firstApp = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstApp) else {
                return nil
            }
            if section.title.isEmpty { return nil }
            
            sectionHeader.title.text = section.title
            sectionHeader.subtitle.text = section.subtitle
            return sectionHeader
            
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            let section = self.sections[sectionIndex]
            
            switch section.type {
            case "smallTable":
                return self.createSmallTableSection()
            case "mediumTable":
                return self.createMediumTableSection()
            default:
                return self.createFeaturedSection()
            }
            
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    //FAQ Section
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(250))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection    }
    
    //Categories Section
    func createMediumTableSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.49))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(0.4))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    //Personal lists section
    func createSmallTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalHeight(0.25))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    //header
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
    
    func loadData() {
        affirmLists = dataManager.loadAffirmLists()
        categories = dataManager.loadCategories()
    }
    
    func loadSectionsAndItems() {
        //append items for section 1
        if let categories = categories {
            for category in categories {
                let isPremium = category.premium == 1 && !iapManager.subscriptionIsActive()
                itemsSection1.append(Item(name: category.name,subtitle: "", imageName: category.name, lock: isPremium))
            }
        }
        //append items for section 2
        if let affirmLists = affirmLists {
            for list in affirmLists {
                itemsSection2.append(Item(name: list.name,subtitle: "", imageName: list.picture, lock: false))
            }
        }
        itemsSection2.append(Item(name: " + add new list",subtitle: "", imageName: "", lock: false))
        //append items for section 3
        itemsSection3.append(Item(name: NSLocalizedString("How to write affirmations", comment: "") ,subtitle: NSLocalizedString("Here you will find a couple of tips on how to write affirmations", comment: "") , imageName: "How to write affirmations", lock: false))
        itemsSection3.append(Item(name: NSLocalizedString("How to use positive affirmations", comment: "") ,subtitle: NSLocalizedString("How to use affirmations effectively to change your life", comment: "") , imageName: "How to work with affirmations", lock: false))
        
        sections = [
        Section(title: NSLocalizedString("Start practice", comment: "") ,subtitle: NSLocalizedString("Powerful Affirmations for every Area of your Life", comment: "") , items: itemsSection1, type: "mediumTable"),
        Section(title: NSLocalizedString("Your personal affirmations lists", comment: "") ,subtitle: NSLocalizedString("Create your own affirmations and your list of affirmations for each day", comment: "") , items: itemsSection2, type: "smallTable"),
        Section(title: "FAQ",subtitle: "", items: itemsSection3, type: "featuredTable")
        ]
        print("sections: \(sections)")
    }
    
    //update categories when subscription is activated/deactivated
    func reloadCategories() {
        itemsSection1.removeAll()
        if let categories = categories {
            for category in categories {
                let isPremium = category.premium == 1 && !iapManager.subscriptionIsActive()
                itemsSection1.append(Item(name: category.name,subtitle: "", imageName: category.name, lock: isPremium))
            }
        }
        sections[0].items = itemsSection1
    }
    
    //update personal lists when  user create/delete list
    func reloadPersonalLists() {
        itemsSection2.removeAll()
        if let affirmLists = affirmLists {
            for list in affirmLists {
                itemsSection2.append(Item(name: list.name,subtitle: "", imageName: list.picture, lock: false))
            }
        }
        itemsSection2.append(Item(name: " + add new list",subtitle: "", imageName: "", lock: false))
        sections[1].items = itemsSection2
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mainToPlaylist" {
            let vc = segue.destination as! PlayListViewController
            guard let selectedIndexPath = selectedIndexPath else { return }
            guard let categories = categories else { return }
            vc.affirmations = categories[selectedIndexPath.row].affirmations
        }
        
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
                    if let indexPath = selectedIndexPath {
                        vc.curList = affirmLists?[indexPath.row]
                    }
                }
            }
        }
        
    }
    
    func checkNewAffirms() {
        let userGender = settings["userGender"]
        //check new categories
        guard let userCategories = categories else { return }//realm.objects(AffirmationsCategory.self)
        var userCategoriesArr: [String] = []
        for cat in userCategories {
            userCategoriesArr.append(cat.name)
        }
        for c in Affirmations.categories {
            if !userCategoriesArr.contains(c) {
                let newCategory = AffirmationsCategory()
                newCategory.name = c
                newCategory.premium = 0
                dataManager.saveCategories(category: newCategory)
            }
        }
        
        for c in Affirmations.premiumCategories {
            if !userCategoriesArr.contains(c) {
                let newCategory = AffirmationsCategory()
                newCategory.name = c
                newCategory.premium = 1
                dataManager.saveCategories(category: newCategory)
            }
        }
        
        //check new affirmations
        for (i,cat) in userCategories.enumerated() {
            var userAffirmations: [String] = []
            for affirm in cat.affirmations {
                userAffirmations.append(affirm.affitmText)
            }
            //standard categories
            if userCategories[i].premium == 0 {
                print()
                print("userCategories \(userCategories)")
                print("userCategoriesCnt \(userCategories.count)")
                print(i)
                print("affTxtCnt = \(Affirmations.affimationsText.count)")
                for a in Affirmations.affimationsText[i] {
                    if !userAffirmations.contains(a) {
                        dataManager.addAffirmation(affirmationTxt: a, to: cat)
                    }
                }
                
                if userGender == 1 {
                    for a in Affirmations.femaleAffirmationsText[i] {
                        if !userAffirmations.contains(a) {
                            dataManager.addAffirmation(affirmationTxt: a, to: cat)
                        }
                    }
                } else {
                    for a in Affirmations.maleAffirmationsText[i] {
                        if !userAffirmations.contains(a) {
                            dataManager.addAffirmation(affirmationTxt: a, to: cat)
                        }
                    }
                }
                //premium categories
            } else {
                let premiumIndex = i - Affirmations.categories.count
                for a in Affirmations.premiumAffimationsText[premiumIndex] {
                    if !userAffirmations.contains(a) {
                        dataManager.addAffirmation(affirmationTxt: a, to: cat)
                    }
                }
                
                if userGender == 1 {
                    for a in Affirmations.femalePremiumAffirmationsText[premiumIndex] {
                        if !userAffirmations.contains(a) {
                            dataManager.addAffirmation(affirmationTxt: a, to: cat)
                        }
                    }
                } else {
                    for a in Affirmations.malePremiumAffirmationsText[premiumIndex] {
                        if !userAffirmations.contains(a) {
                            dataManager.addAffirmation(affirmationTxt: a, to: cat)
                        }
                    }
                }
            }
            
            
        }
    }
    
    func checkFirstLauch() {
        let userGender = settings["userGender"]
        if LandscapeManager.shared.isFirstLaunch {
            //performSegue(withIdentifier: "toOnboarding", sender: nil)
            for c in Affirmations.categories {
                let newCategory = AffirmationsCategory()
                newCategory.name = c
                dataManager.saveCategories(category: newCategory)
            }
            
            let categoriesObj = realm.objects(AffirmationsCategory.self)
            
            for (n,cat) in categoriesObj.enumerated() {
                for af in Affirmations.affimationsText[n] {
                    dataManager.addAffirmation(affirmationTxt: af, to: cat, withSound: af)
                }
                if userGender == 1 {
                    for af in Affirmations.femaleAffirmationsText[n] {
                        dataManager.addAffirmation(affirmationTxt: af, to: cat, withSound: af)
                    }
                } else {
                    for af in Affirmations.maleAffirmationsText[n] {
                        dataManager.addAffirmation(affirmationTxt: af, to: cat, withSound: af)
                    }
                }
                
            }
            
            let premiumCategories = realm.objects(AffirmationsCategory.self).filter("premium = 1")
            
                for c in Affirmations.premiumCategories {
                    let newCategory = AffirmationsCategory()
                    newCategory.name = c
                    newCategory.premium = 1
                    dataManager.saveCategories(category: newCategory)
                }
                for (n,cat) in premiumCategories.enumerated() {
                    for af in Affirmations.premiumAffimationsText[n] {
                        dataManager.addAffirmation(affirmationTxt: af, to: cat, withSound: af)
                    }
                    if userGender == 1 {
                        for af in Affirmations.femalePremiumAffirmationsText[n] {
                            dataManager.addAffirmation(affirmationTxt: af, to: cat, withSound: af)
                        }
                    } else {
                        for af in Affirmations.malePremiumAffirmationsText[n] {
                            dataManager.addAffirmation(affirmationTxt: af, to: cat, withSound: af)
                        }
                    }
                }
            
            LandscapeManager.shared.isFirstLaunch = true
        }
    }
    
    //MARK: - compare widget affirms count with affirm in stored lists
    
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
        for item in sections[0].items {
            if item.lock {
                loadData()
                reloadCategories()
                reloadData()
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
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath)
        if indexPath.section == 0 {
            guard let categories = categories else { return }
            if categories[indexPath.row].premium == 1 {
                if !iapManager.subscriptionIsActive() {
                    performSegue(withIdentifier: "mainToSubscriptions", sender: self)
                }
            }
            selectedIndexPath = indexPath
            performSegue(withIdentifier: "mainToPlaylist", sender: self)
        }
        if indexPath.section == 1 {
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
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "mainToHowWrite", sender: self)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "mainToHowToUse", sender: self)
            }
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if let list = affirmLists {
            if indexPath.row < list.count {
                return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                    
                    // Create an action for sharing
                    let delete = UIAction(title: NSLocalizedString("Delete", comment: ""), image: UIImage(systemName: "trash")) { action in
                        print("deleting")
                        self.dataManager.deleteList(list: list[indexPath.row])
                        self.sections[1].items.remove(at: indexPath.row)
                        self.collectionView.reloadData()
                        self.reloadData()
                    }
                    
                    let edit = UIAction(title: NSLocalizedString("Edit", comment: ""), image: UIImage(systemName: "pencil")) { (action) in
                        print("edit")
                        self.editList = true
                        self.selectedIndexPath = indexPath
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





