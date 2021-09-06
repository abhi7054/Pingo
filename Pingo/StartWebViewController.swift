//
//  StartWebViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 23/07/21.
//

import UIKit

class StartWebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("WhatsAppSuccess"), object: nil)
        
        AppUtility.lockOrientation(.portrait)
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        print("Test")
        let objStartWebViewController = WebHelperViewController()
        self.navigationController?.pushViewController(objStartWebViewController, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("WhatsAppSuccess"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationItem.backButtonTitle = ""
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
       
    }
    
    func isPurchased() -> Bool {
        if UserDefaults.standard.string(forKey: "purchased") == "1" {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        if isPurchased() {
            let objStartWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebHelperViewController") as! WebHelperViewController
            self.navigationController?.pushViewController(objStartWebViewController, animated: true)
        } else {
            let objSubscribeViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscribeViewController") as! SubscribeViewController
            objSubscribeViewController.strFrom = "WhatsApp"
            objSubscribeViewController.modalPresentationStyle = .overFullScreen
            self.present(objSubscribeViewController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
