//
//  ThirdStepViewController.swift
//  Affirmatio
//
//  Created by evpes on 12.05.2021.
//

import UIKit
import StoreKit
import RealmSwift

class ThirdStepViewController: UIViewController {
    
    @IBOutlet weak var buttonOutlet: UIButton!
    var bgView: GradientBackground?
  //  @IBOutlet weak var tileView: UIView!
    
    @IBOutlet weak var Subscription12M: SubscriptionView!
    @IBOutlet weak var Subscription6M: SubscriptionView!
    @IBOutlet weak var Subscription1M: SubscriptionView!
    
    let realm = try! Realm()
    let dataManager = DataManager()
    let iapManager = IAPManager.shared
    let notificationCenter = NotificationCenter.default
    
    //let iAPHelper = IAPHelper(productIds: Set(["com.apsterio.Affirmatio.premium","com.apsterio.Affirmatio.premium6m","com.apsterio.Affirmatio.premium12m"]))
    
    //let productIDs = ["com.apsterio.Affirmatio.premium","com.apsterio.Affirmatio.premium6m","com.apsterio.Affirmatio.premium12m"]
    
    
    var subscriprionViews : [SubscriptionView] = []
    
    var selectedSubscription = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        notificationCenter.addObserver(self, selector: #selector(setSubscriptionInfo), name: NSNotification.Name(IAPManager.productNotificationID), object: nil)
        notificationCenter.addObserver(self, selector: #selector(setPremium), name: NSNotification.Name(IAPProduct.premiumSubscription.rawValue), object: nil)
        
        SKPaymentQueue.default().add(self)
        
        subscriprionViews = [Subscription12M,Subscription6M,Subscription1M]
        
        buttonOutlet.layer.cornerRadius = 15
        //buttonOutlet.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
//        tileView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
//        tileView.layer.cornerRadius = 15
        
        //Subscription1M.price.text = "price"
        
        for (n,view) in subscriprionViews.enumerated() {
            view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            view.layer.cornerRadius = 15
            switch n {
            case 0:
                view.period.text = NSLocalizedString("1 year", comment: "")
                view.price.text = "8.49$"
                view.trial.text = NSLocalizedString("7 days free", comment: "")
                view.button.addTarget(self, action: #selector(selectSubscriptionPeriod), for: .touchUpInside)
                view.button.tag = n
            case 1:
                view.period.text = NSLocalizedString("6 months", comment: "")
                view.price.text = "5.49$"
                view.trial.text = NSLocalizedString("3 days free", comment: "")
                view.button.addTarget(self, action: #selector(selectSubscriptionPeriod), for: .touchUpInside)
                view.button.tag = n
            case 2:
                view.period.text = NSLocalizedString("1 month", comment: "")
                view.price.text = "0.99$"
                view.trial.text = ""
                view.button.addTarget(self, action: #selector(selectSubscriptionPeriod), for: .touchUpInside)
                view.button.tag = n
            default:
                print("default")
            }
            
            Subscription12M.backgroundColor = .black.withAlphaComponent(0.8)
            Subscription12M.price.textColor = .white
            Subscription12M.trial.textColor = .white
            Subscription12M.period.textColor = .white
            
            print("iapManager.products \(iapManager.products)")
            if iapManager.products.count > 0 {
                setSubscriptionInfo()
            }
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func setSubscriptionInfo() {
        for p in iapManager.products {
            DispatchQueue.main.async {
                print("setup subscription for \(p)")
                switch p.productIdentifier {
                case "com.apsterio.Affirmatio.premium":
                    print("price = \(p.localizedPrice) period = \(p.localizedTitle) trial = \(p.localizedDescription)")
                    self.Subscription1M.price.text = p.localizedPrice
                    self.Subscription1M.period.text = p.localizedTitle
                    self.Subscription1M.trial.text = p.localizedDescription
                case "com.apsterio.Affirmatio.premium12m":
                    print("price = \(p.localizedPrice) period = \(p.localizedTitle) trial = \(p.localizedDescription)")
                    self.Subscription12M.price.text = p.localizedPrice
                    self.Subscription12M.period.text = p.localizedTitle
                    self.Subscription12M.trial.text = p.localizedDescription
                case "com.apsterio.Affirmatio.premium6m":
                    print("price = \(p.localizedPrice) period = \(p.localizedTitle) trial = \(p.localizedDescription)")
                    self.Subscription6M.price.text = p.localizedPrice
                    self.Subscription6M.period.text = p.localizedTitle
                    self.Subscription6M.trial.text = p.localizedDescription
                default:
                    print("default")
                }
            }
        }
    }
    
    @objc private func setPremium() {
        print("set premium in third view controller")
//        let premiumCategories = realm.objects(AffirmationsCategory.self).filter("premium = 1")
//        if premiumCategories.count == 0 {
//            for c in Affirmations.premiumCategories {
//                let newCategory = AffirmationsCategory()
//                newCategory.name = c
//                newCategory.premium = 1
//                dataManager.saveCategories(category: newCategory)
//            }
//            for (n,cat) in premiumCategories.enumerated() {
//                for af in Affirmations.premiumAffimationsText[n] {
//                    dataManager.addAffirmation(affirmationTxt: af, to: cat)
//                }
//            }
//        }
        //self.dismiss(animated: true, completion: nil) --old
        //addPremiumContent()
        
        //new
        if let _ = parent as? MainPageViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootController(mainNavigationController)
            //pageController.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
    }
    
    
    @IBAction func restorePressed(_ sender: UIButton) {
        iapManager.restoreCompletedTransactions()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
//old
        //        if let pageController = parent as? MainPageViewController {
//            pageController.dismiss(animated: true, completion: nil)
//        } else {
//            self.dismiss(animated: true, completion: nil)
//        }
        //new
        if let _ = parent as? MainPageViewController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootController(mainNavigationController)
            //pageController.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func selectSubscriptionPeriod(_ sender: UIButton) {
        selectedSubscription = sender.tag
        for v in subscriprionViews {
            if v.button.tag == sender.tag {
                v.backgroundColor = .black.withAlphaComponent(0.8)
                v.price.textColor = .white
                v.trial.textColor = .white
                v.period.textColor = .white
            } else {
                v.backgroundColor = .white.withAlphaComponent(0.2)
                v.price.textColor = .black
                v.trial.textColor = .black
                v.period.textColor = .black
            }
        }
        
    }
    
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        print("buy try")
        // 0 - 12m   1 - 6m   2 - 1m
        switch selectedSubscription {
        case 0: iapManager.purchase(productWith: IAPProduct.twelveMonths.rawValue)
        case 1: iapManager.purchase(productWith: IAPProduct.sixMonths.rawValue)
        case 2: iapManager.purchase(productWith: IAPProduct.oneMonth.rawValue)
        default:
            print("")
        }
        //self.dismiss(animated: true, completion: nil)
        
        //print(iAPHelper.products)
        //        if checkPurchase() {
        //            self.dismiss(animated: true, completion: nil)
        //        } else {
        //            if let products = iAPHelper.products {
        //                print(products)
        //                switch selectedSubscription {
        //                case 0:
        //                    iAPHelper.buyProduct(products[0])
        //                case 1:
        //                    iAPHelper.buyProduct(products[1])
        //                case 2:
        //                    iAPHelper.buyProduct(products[2])
        //                default:
        //                    print("default")
        //                }
        //            }
        //        }
        //        if checkPurchase() {
        //            addPremiumContent()
        //        }
        
    }
    
    @IBAction func termsButton(_ sender: Any) {
        if let url = URL(string: "https://evpes.github.io/cv/terms_affirmare.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyButton(_ sender: Any) {
        if let url = URL(string: "https://evpes.github.io/cv/privacy_Affirmare.html") {
            UIApplication.shared.open(url)
        }
    }
    
    
    
//    func addPremiumContent() {
//        let premiumCategories = realm.objects(AffirmationsCategory.self).filter("premium = 1")
//        if premiumCategories.count == 0 {
//            for c in Affirmations.premiumCategories {
//                let newCategory = AffirmationsCategory()
//                newCategory.name = c
//                newCategory.premium = 1
//                dataManager.saveCategories(category: newCategory)
//            }
//            for (n,cat) in premiumCategories.enumerated() {
//                for af in Affirmations.premiumAffimationsText[n] {
//                    dataManager.addAffirmation(affirmationTxt: af, to: cat)
//                }
//            }
//        }
//    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ThirdStepViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //user payment succ
            } else if transaction.transactionState == .failed {
                //transaction failed
            }
        }
    }
    
    
}
