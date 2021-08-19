//
//  SubscribeViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 15/08/21.
//

import UIKit

class SubscribeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnWeeklyClick(_ sender: UIButton) {
        IAPHelper.shared.purchase(product: .weekly)
    }
    
    @IBAction func btnMonthlyClick(_ sender: UIButton) {
        IAPHelper.shared.purchase(product: .monthly)
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restorePurchasesButton(_ sender: Any) {
        IAPHelper.shared.restorePurchase()
    }
   
    
}
