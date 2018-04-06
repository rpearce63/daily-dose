//
//  ViewController.swift
//  daily-dose
//
//  Created by Rick Pearce on 4/5/18.
//  Copyright © 2018 Rick Pearce. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var removeAdsBtn: UIButton!
    @IBOutlet weak var adsView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var restoreBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    func setupView() {
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS) {
            bannerView.removeFromSuperview()
            removeAdsBtn.removeFromSuperview()
            restoreBtn.removeFromSuperview()
        } else {
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }

    @IBAction func restoreBtnPressed(_ sender: Any) {
        PurchaseManager.instance.restorePurchases { success in
            if success {
                UserDefaults.standard.set(true, forKey: PurchaseManager.instance.IAP_REMOVE_ADS)
                self.setupView()
            } else {
                print("not able to restore purchases")
            }
        }
    }
    
    @IBAction func removeAdsPressed(_ sender: Any) {
        // show a loading spinner ActivityIndicator
        spinner.isHidden = false
        spinner.startAnimating()
        PurchaseManager.instance.purchaseRemoveAds { (success) in
            if success {
                self.setupView()
            } else {
                print("could not remove ads")
            }
        }
        self.spinner.stopAnimating()
    }
    
}

