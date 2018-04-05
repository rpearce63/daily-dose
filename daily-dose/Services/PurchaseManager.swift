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
        let productIds = NSSet(objects: IAP_REMOVE_ADS) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("productsRequest didReceive")
        products = response.products
        for product in products {
            print(product.productIdentifier)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("failed to get products - Error \(error.localizedDescription)")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
}
