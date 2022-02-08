//
//  MainSubscriptionViewController.swift
//  Affirmatio
//
//  Created by evpes on 24.01.2022.
//

import UIKit
import StoreKit

class MainSubscriptionViewController: UIViewController {

    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var subscibeButtonOL: UIButton!
    
    var bgView: GradientBackground?
    
    let iapManager = IAPManager.shared
    let notificationCenter = NotificationCenter.default
    
    //First 7 days are free, then 50$/ year.
    //Cancel anytime.
    let firstPartLabelText = NSLocalizedString("First 7 days are free, then ", comment: "")
    let secondPartLabelText =  NSLocalizedString("/ year.\nCancel anytime.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscibeButtonOL.layer.cornerRadius = 15
        
        notificationCenter.addObserver(self, selector: #selector(setSubscriptionInfo), name: NSNotification.Name(IAPManager.productNotificationID), object: nil)
        notificationCenter.addObserver(self, selector: #selector(setPremium), name: NSNotification.Name(IAPProduct.premiumSubscription.rawValue), object: nil)
        
        SKPaymentQueue.default().add(self)
        bgView = GradientBackground(frame: self.view.bounds)
        self.view.insertSubview(bgView!, at: 0)
        
        if iapManager.products.count > 0 {
            setSubscriptionInfo()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bgView?.animateGradient()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
        iapManager.purchase(productWith: IAPProduct.twelveMonths.rawValue)
    }
    
    
    @IBAction func policyButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://evpes.github.io/cv/privacy_Affirmare.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://evpes.github.io/cv/terms_affirmare.html") {
            UIApplication.shared.open(url)
        }
    }

    
    @IBAction func allPlansButtonTapped(_ sender: Any) {
        if let pageController = parent as? MainPageViewController {
                pageController.pushNext()
            }
    }
    
    @objc private func setPremium() {
        //go to main VC
        print("set premium in main subscription view controller")
        //self.dismiss(animated: true, completion: nil) //old
        
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
    
    @IBAction func restorePressed(_ sender: UIButton) {
        iapManager.restoreCompletedTransactions()
    }
    
    @objc private func setSubscriptionInfo() {
        for p in iapManager.products {
            DispatchQueue.main.async {
                print("setup subscription for \(p)")
                switch p.productIdentifier {
                case "com.apsterio.Affirmatio.premium12m":
                    print("price = \(p.localizedPrice) period = \(p.localizedTitle) trial = \(p.localizedDescription)")
                    self.priceLabel.text = self.firstPartLabelText + p.localizedPrice + self.secondPartLabelText
                default:
                    print("default")
                }
            }
        }
    }
    


}

//@IBAction func restorePressed(_ sender: UIButton) {
//    iapManager.restoreCompletedTransactions()
//}
//
//@IBAction func closeButtonPressed(_ sender: Any) {
//    if let pageController = parent as? MainPageViewController {
//        pageController.dismiss(animated: true, completion: nil)
//    } else {
//        self.dismiss(animated: true, completion: nil)
//    }
//}

extension MainSubscriptionViewController: SKPaymentTransactionObserver {
    
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
