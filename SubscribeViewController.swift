//
//  SubscribeViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 15/08/21.
//

import UIKit
import StoreKit

struct AddSubscriptionData: Codable {
    let response: Int
}

class SubscribeViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
   
    var strFrom = String()
    var productsRequest: SKProductsRequest!
    let weeklyProductID = "weekly"
    let monthProductID = "monthly"
    @IBOutlet weak var monthlyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        if AppShared.shared.id == 1 {
            monthlyButton.setTitle(NSLocalizedString("continue free", tableName: "Main", comment: ""), for: .normal)
        }else{
            monthlyButton.setTitle(NSLocalizedString("bYM-WF-5lT.normalTitle", tableName: "Main", comment: ""), for: .normal)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.monthlyButton.pulse(withIntensity: 0.9, withDuration: 0.6, loop: true)
    }
    
    @IBAction func btnWeeklyClick(_ sender: UIButton) {
        
        if (SKPaymentQueue.canMakePayments()) {
            let productID:NSSet = NSSet(object: self.weeklyProductID);
            productsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
        }else{
            print("Can't make purchases");
        }
    }
    
    @IBAction func btnMonthlyClick(_ sender: UIButton) {
        if (SKPaymentQueue.canMakePayments()) {
            let productID:NSSet = NSSet(object: self.monthProductID);
            productsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fetching Products");
        }else{
            print("Can't make purchases");
        }
        monthlyButton.layer.removeAllAnimations()
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restorePurchaseButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Pingo App", message: "If you have a subscribe, please close/open app 2-3 times.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchasing, .deferred: break
                case .purchased, .restored:
                    SKPaymentQueue.default().finishTransaction(transaction)
                    NetworkRequestMaker.makePostRequest(url: "http://back-api.com/pingo/api/Purchase.php", urlParameters: "deviceid=\(AppShared.shared.deviceID!) &receiptkey=\(AppShared.shared.transactionReceipt!)"){data in
                        
                            let decoder = JSONDecoder()
                            do {
                                let json: AddSubscriptionData = try! decoder.decode(AddSubscriptionData.self, from: data)
                                print("Purchase response", json)
                                
                                if json.response == 1{
                                    AppShared.shared.purchased = 1
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: true) {
                                                if self.strFrom == "WhatsApp" {
                                                    NotificationCenter.default.post(name: Notification.Name("WhatsAppSuccess"), object: nil)
                                                    print("if")
                                                }else {
                                                    print("else")
                                                    NotificationCenter.default.post(name: Notification.Name("WallPaperSuccess"), object: nil)
                                                }
                                        }
                                    }
                                    
                                }
                                
                            }catch{
                                print(error.localizedDescription)
                            }
                        
                    }
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction)
                   print("failed")
                @unknown default:
                    break
                }
            }
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
           
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(product: validProduct);
           
        } else {
            print("nothing")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error Fetching product information");
    }
}

extension UIView {
    func pulse(withIntensity intensity: CGFloat, withDuration duration: Double, loop: Bool) {
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            loop ? nil : UIView.setAnimationRepeatCount(1)
            self.transform = CGAffineTransform(scaleX: intensity, y: intensity)
        }) { (true) in
            self.transform = CGAffineTransform.identity
        }
    }
}
