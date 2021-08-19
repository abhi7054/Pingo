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
        AppUtility.lockOrientation(.portrait)
        
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
        if AppPrefsManager.sharedInstance.getSubscriptionDetails() == 0 {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        if isPurchased() {
            let objStartWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebHelperViewController") as! WebHelperViewController
            self.navigationController?.pushViewController(objStartWebViewController, animated: true)
        } else {
            let objSubscribeViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscribeViewController") as! SubscribeViewController
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
