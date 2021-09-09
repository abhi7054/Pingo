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
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
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
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restorePurchaseButton(_ sender: UIButton) {
        SKPaymentQueue.default().restoreCompletedTransactions()
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


