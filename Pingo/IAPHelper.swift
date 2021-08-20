//
//  IAPHelper.swift
//  
//
//

import Foundation
import UIKit
import StoreKit


enum IAPProduct: String {
    case weekly = "weekly" // weekly
    case monthly = "monthly" // speakon
}

class IAPHelper: NSObject,SKRequestDelegate  {
    var DEVICEID:String?
    static let shared = IAPHelper()
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    override init() {
        super.init()
        DEVICEID = AppDelegate().deviceID
        //never change this variable, app will handle itself sandbox/production modes
        let receipt = getTransactionReceipt()
        print("Receipt key = ",receipt)
        
        if(receipt.isEmpty){
            restorePurchases()
        }else {
            receiptValidation(isDebug: false)
        }
        
    }
    
    func getProducts() {
        let product: Set = [IAPProduct.weekly.rawValue, IAPProduct.monthly.rawValue]
        let request = SKProductsRequest(productIdentifiers: product)
        request.delegate = self
        request.start()
        
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchase() {
           SKPaymentQueue.default().restoreCompletedTransactions()
       }
    
    
    
    //important function : used to get receipt from phone
    func getTransactionReceipt() -> String {
        // Get the receipt if it's available
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                //print(receiptData)
                let receiptString = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
               // print("orignal :\(receiptString)")
                return receiptString

            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
        }
        return ""
    }
    
    public func restorePurchases() {
        //SKPaymentQueue.default().add(self)
        //SKPaymentQueue.default().restoreCompletedTransactions()
        print("restored called")
        let request = SKReceiptRefreshRequest(receiptProperties: nil)
            request.delegate = self
            request.start()
    }
    func requestDidFinish(_ request: SKRequest) {
        print("refresh called")
      // call refresh subscriptions method again with same blocks
        if request is SKReceiptRefreshRequest {
            print("refresh called")
            receiptValidation(isDebug: false)
        }
    }
    
    // important function validate receipt
    func receiptValidation(isDebug:Bool) {
        var  urlString = "https://buy.itunes.apple.com/verifyReceipt"
        if(isDebug){
            urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
        }else{
            urlString = "https://buy.itunes.apple.com/verifyReceipt"
        }
        
        let receipt = getTransactionReceipt()
        print("receipt \(receipt)")
        if(receipt.isEmpty){
            checkSubStatus()
            return
        }
        let jsonDict: [String: AnyObject] = ["receipt-data" :receipt  as AnyObject, "password" : "79de16cc43394000b11fdd6672d06a86" as AnyObject]
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: urlString)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            print("working: \(requestData)")
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: {(data, response, error) in
                do {
                    if let dataJson = data {
                        guard let jsonResponse = (try? JSONSerialization.jsonObject(with: dataJson, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any] else {
                                    return
                        }
                        print(jsonResponse)
                        self.receiptInfo(jsonResponse: jsonResponse)

                    }else{
                        self.checkSubStatus()
                    }
                }
            })
            task.resume()
        } catch let parseError {
            print(parseError)
        }
    }
    func receiptInfo(jsonResponse: [AnyHashable: Any]){
        if(jsonResponse["status"] as? Int == 0){
        }else{
            if(jsonResponse["status"] as? Int == 21007){
                self.receiptValidation(isDebug: true)
            }
            return
            //return nil
        }
        guard let receiptInfo = (jsonResponse["latest_receipt_info"] as? [[AnyHashable: Any]]) else {
            return
        }
        
        var purchase = [AnyHashable: Any]()
        var largestNumber:String = "";
        
        if receiptInfo.count > 1 {
            purchase = receiptInfo[0]
            largestNumber = receiptInfo[0]["expires_date_ms"] as! String
        }
        
        for AnyObject in receiptInfo {
            let number = AnyObject["expires_date_ms"] as! String
            if(number > largestNumber){
                purchase = AnyObject
                largestNumber = number
            }
        }
        savePurchaseInformation(purchase: purchase)
    }
    func savePurchaseInformation(purchase: [AnyHashable: Any])  {
        UserDefaults.standard.set(purchase["expires_date_ms"] , forKey: "expires_date_ms")
        UserDefaults.standard.set(purchase["purchase_date_ms"] , forKey: "purchase_date_ms")
        
        UserDefaults.standard.set(purchase["product_id"] , forKey: "product_id")
        UserDefaults.standard.set(purchase["original_transaction_id"] , forKey: "original_transaction_id")
        
        let expiresString:String = purchase["expires_date"] as! String
        let purchaseString:String = purchase["purchase_date"] as! String
        
        checkSubStatus()
    }
    
    func checkSubStatus() {
        if let _ = UserDefaults.standard.string(forKey: "original_transaction_id") {
            
        }else{
            //no purchase yet
            print("No purchase found")
            sendDataToServer(isSubFound: false)
            return;
        }
        let now = Date()
        print(now)
        let now_sec:Int64 = Int64(now.timeIntervalSince1970 * 1000)
        if let expires_date_ms = UserDefaults.standard.string(forKey: "expires_date_ms"){
            let expires_date_ms2 = Int64(expires_date_ms)!
            print("nowSec: \(now_sec) ex_sec: \(expires_date_ms2)")
            if(expires_date_ms2 > now_sec ){
                print("active sub found using expiry date")
                sendDataToServer(isSubFound: true)
            }else{
                sendDataToServer(isSubFound: false)
            }
        }
    }

    func sendDataToServer(isSubFound:Bool) {
        var urlParameters =  [String: String]()
        if let deviceId = self.DEVICEID {
            urlParameters["deviceid"] = deviceId
        }else{
            urlParameters["deviceid"] = ""
        }
        
        if(isSubFound){
            urlParameters["original_transaction_id"] = UserDefaults.standard.string(forKey: "original_transaction_id")!
            urlParameters["product_id"] = UserDefaults.standard.string(forKey: "product_id")!
            urlParameters["expires_date_ms"] = UserDefaults.standard.string(forKey: "expires_date_ms")!
            urlParameters["purchase_date_ms"] = UserDefaults.standard.string(forKey: "purchase_date_ms")!
        }else{
            urlParameters["product_id"] = "0"
        }
        
        //encode parameters
        var parameters = NetworkRequestMaker.getUrlParameters2(urlParameters: urlParameters)
//        parameters=Cryption.Encrypt(plainTextData: parameters)
        
        NetworkRequestMaker.makePostRequest(url: "http://back-api.com/pingo/api/takeVerifyReceipt.php", urlParameters: parameters) { (result:Data) in
            let requestRes = String(decoding: result, as: UTF8.self)
            print(requestRes)
        }
    }
}

extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        self.products = response.products
        for products in response.products {
            print("Product Name : ",products.localizedTitle)
        }
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState)
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction as SKPaymentTransaction)
                //denny
                // set delegate to dismiss current view controller
                if transaction.payment.productIdentifier == IAPProduct.weekly.rawValue {
                    func getUserSubscription(completion: @escaping (CheckSubscriptionData)-> ()) {
                        
                        let receipt = getTransactionReceipt()
                        let urlString = "http://back-api.com/pingo/api/checkSubscription.php?deviceid=\(DEVICEID ?? "")&receiptkey=\(receipt)"
                        if let url = URL(string: urlString) {
                            URLSession.shared.dataTask(with: url) {data, res, err in
                                if let data = data {
                                    let decoder = JSONDecoder()
                                    do {
                                        let json: CheckSubscriptionData = try! decoder.decode(CheckSubscriptionData.self, from: data)
                                        AppPrefsManager.sharedInstance.setSubscriptionDetails(obj: json.purchase)
                                        completion(json)
                                    }
                                }
                            }.resume()
                        }
                    }
                } else if transaction.payment.productIdentifier == IAPProduct.monthly.rawValue {
                    func getUserSubscription(completion: @escaping (CheckSubscriptionData)-> ()) {
                        let receipt = getTransactionReceipt()
                        let urlString = "http://back-api.com/pingo/api/checkSubscription.php?deviceid=\(DEVICEID ?? "")&receiptkey=\(receipt)"
                        if let url = URL(string: urlString) {
                            URLSession.shared.dataTask(with: url) {data, res, err in
                                if let data = data {
                                    let decoder = JSONDecoder()
                                    do {
                                        let json: CheckSubscriptionData = try! decoder.decode(CheckSubscriptionData.self, from: data)
                                        AppPrefsManager.sharedInstance.setSubscriptionDetails(obj: json.purchase)
                                        completion(json)
                                    }
                                }
                            }.resume()
                        }
                    }
                }
                

                break
            default: queue.finishTransaction(transaction)
                
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred:
            return "deferred"
        case .failed:
            return "failed"
        case .purchased:
            return "purchased"
        case .purchasing:
            return "purchasing"
        case .restored:
            return "restored"
        default:
            return ""
        }
    }
}


extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd hh:mm:ss")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
        
    }
}
