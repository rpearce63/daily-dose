//
//  PurchaseManager.swift
//  daily-dose
//
//  Created by Rick Pearce on 4/5/18.
//  Copyright © 2018 Rick Pearce. All rights reserved.
//

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let instance = PurchaseManager()
    
    let IAP_REMOVE_ADS = "com.pearce.rick.daily.dose.remove.ads"
    
    var productsRequest : SKProductsRequest?
    var products = [SKProduct]()
    
    func fetchProducts() {
        let productIds : Set<String> = [IAP_REMOVE_ADS]
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    func purchaseRemoveAds() {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            let removeAdProduct = products[0]
            let payment = SKPayment(product: removeAdProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        products = response.products
        print("Received \(products.count) products in the request")
        for product in products {
            print(product.productIdentifier)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("failed to get products - Error \(error.localizedDescription)")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                }
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            default: break
            }
        }
    }
}
