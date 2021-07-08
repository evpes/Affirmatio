//
//  IAPManager.swift
//  Affirmatio
//
//  Created by evpes on 10.06.2021.
//

import Foundation
import StoreKit

class IAPManager: NSObject {
            
    
    static let shared = IAPManager()
    static let productNotificationID = "IAPManagerProductID"
    private override init() {}
    
    var products: [SKProduct] = []
    let paymentQueue = SKPaymentQueue.default()
    
    public func setupPurchases(callback: @escaping(Bool) -> () ) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            callback(true)
            return
        }
        callback(false)
    }
    
    public func getProducts() {
        let identifiers: Set = [
            "com.apsterio.Affirmatio.premium",
            "com.apsterio.Affirmatio.premium6m",
            "com.apsterio.Affirmatio.premium12m"
        ]
        
        let productsRequest = SKProductsRequest(productIdentifiers: identifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    public func purchase(productWith identifier: String) {
        guard let product = products.filter({ $0.productIdentifier == identifier}).first else {
            return
        }
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }
    
    public func restoreCompletedTransactions() {
        paymentQueue.restoreCompletedTransactions()
    }
    
    public func checkSubscriptionPeriod() {
        print("Check subscription period")
        guard let subscriptionExpDate = UserDefaults.standard.object(forKey: "expDate") as? Date else {
            return
        }
        print("Subscription expiration date :\(subscriptionExpDate)")
        if subscriptionExpDate < Date() {
            UserDefaults.standard.set(false, forKey: IAPProduct.premiumSubscription.rawValue)
        }
        print("premium subscription availability : \(UserDefaults.standard.bool(forKey: IAPProduct.premiumSubscription.rawValue))")
    }
    
    public func subscriptionIsActive() -> Bool {
        return UserDefaults.standard.bool(forKey: IAPProduct.premiumSubscription.rawValue)
    }
    
}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print("transaction ; \(transaction)")
            switch  transaction.transactionState {
            case .deferred:
                break
            case .purchasing:
                break
            case .failed:
                print("failed")
                fail(transaction: transaction)
            case .purchased:
                print("purchased")
                parseReceipt(transaction: transaction)
            case .restored:
                print("restored")
                parseReceipt(transaction: transaction)
            @unknown default:
                print("Get unknown status in paymentQueue")
            }
        }
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue
            {
                print("Transaction error \(transaction.error!.localizedDescription)")
            }
        }
        paymentQueue.finishTransaction(transaction)
    }
    
    private func parseReceipt(transaction: SKPaymentTransaction) {
        
        let receiptValidator = ReceiptValidator()
        let result = receiptValidator.validateReceipt()
        print("completed validator")
        switch result {
        case let .success(receipt):
            //print("receipts \(receipt.inAppPurchaseReceipts)")
            ///set maximum expirationDate from receipts array
            if let receipts = receipt.inAppPurchaseReceipts {
                for receipt in receipts {
                    print("check receip in receipts Arr : \(receipt)")
                    if let expirationDate = receipt.subscriptionExpirationDate {
                        print("receipt expDate = \(expirationDate)")
                        if let currentExpDate = UserDefaults.standard.object(forKey: "expDate") as? Date {
                            print("current date = \(currentExpDate)")
                            if expirationDate > currentExpDate {
                                print("expirationDate > currentExpDate")
                                UserDefaults.standard.set(true, forKey: IAPProduct.premiumSubscription.rawValue)
                                UserDefaults.standard.set(expirationDate, forKey: "expDate")
                                //print("set exp date : \(UserDefaults.standard.object(forKey: "expDate"))")
                            }
                        } else {
                        UserDefaults.standard.set(true, forKey: IAPProduct.premiumSubscription.rawValue)
                        UserDefaults.standard.set(expirationDate, forKey: "expDate")
                        //print("set exp date at the end: \(UserDefaults.standard.object(forKey: "expDate"))")
                        }
                    }
                }
            }
            guard let expDate = UserDefaults.standard.object(forKey: "expDate") as? Date else {
                UserDefaults.standard.set(false, forKey: IAPProduct.premiumSubscription.rawValue)
                paymentQueue.finishTransaction(transaction)
                return
            }
            print("expDate \(expDate)")
            if expDate < Date() {
                UserDefaults.standard.set(false, forKey: IAPProduct.premiumSubscription.rawValue)
            } else {
                UserDefaults.standard.set(true, forKey: IAPProduct.premiumSubscription.rawValue)
            }
            NotificationCenter.default.post(name: NSNotification.Name(IAPProduct.premiumSubscription.rawValue), object: nil)
        case let .error(error):
            print("Error in receipt validation process: \(error)")
            break
        
        }
        
        
        paymentQueue.finishTransaction(transaction)
    }
    
    private func restored(transaction: SKPaymentTransaction) {
        paymentQueue.finishTransaction(transaction)
    }
    
    
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        products.forEach { print("product title\($0.localizedTitle) \($0.price) \($0.productIdentifier)") }
        if products.count > 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPManager.productNotificationID), object: nil)
            print("add notification")
        }
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
