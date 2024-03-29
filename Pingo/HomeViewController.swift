//
//  ViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 23/07/21.
//

import UIKit

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var settingsVIew: UIView!
    @IBOutlet weak var homeView: UIView!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("WallPaperSuccess"), object: nil)
        
        setupBackButton()
        AppUtility.lockOrientation(.portrait)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        print("reached")
        let objStartWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WallpapersViewController") as! WallpapersViewController
        self.navigationController?.pushViewController(objStartWebViewController, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("WallPaperSuccess"), object: nil)
    }

    @IBAction func homeAction(_ sender: Any) {
        
        homeButton.setBackgroundImage(UIImage(named: "iconHomeSelected"), for: .normal)
        settingsButton.setBackgroundImage(UIImage(named: "iconSettingsUnSelect"), for: .normal)
        homeView.isHidden = false
        settingsVIew.isHidden = true
    }
    @IBAction func settingAction(_ sender: Any) {
        
        homeButton.setBackgroundImage(UIImage(named: "iconHomeUnSelect"), for: .normal)
        settingsButton.setBackgroundImage(UIImage(named: "iconSettingsSelected"), for: .normal)
        homeView.isHidden = true
        settingsVIew.isHidden = false
    }
    
    @IBAction func userAgreementAction(_ sender: Any) {
        
        Constants.title = "User Agreement"
        Constants.websiteURL = "https://omboinc.com/pingo/"
        Constants.websiteURL = Constants.websiteURL+Constants.agreement
    }
    @IBAction func policyAction(_ sender: Any) {
        
        Constants.title = "Policy"
        Constants.websiteURL = "https://omboinc.com/pingo/"
        Constants.websiteURL = Constants.websiteURL+Constants.policy
    }
    @IBAction func contact(_ sender: Any) {
        
        Constants.title = "Contact"
        Constants.websiteURL = "https://omboinc.com/pingo/"
        Constants.websiteURL = Constants.websiteURL+Constants.contact
    }
    @IBAction func pingoWebsiteAction(_ sender: Any) {
        Constants.title = "Pingo"
        Constants.websiteURL = "https://omboinc.com/pingo/"
    }
    
    func isPurchased() {
        if AppShared.shared.purchased == 1 {
                DispatchQueue.main.async {
                    let objStartWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WallpapersViewController") as! WallpapersViewController
                    self.navigationController?.pushViewController(objStartWebViewController, animated: true)
                }
               
            }else {
                DispatchQueue.main.async {
                    let objSubscribeViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscribeViewController") as! SubscribeViewController
                    objSubscribeViewController.strFrom = "Wallpaper"
                    objSubscribeViewController.modalPresentationStyle = .overFullScreen
                    self.present(objSubscribeViewController, animated: true, completion: nil)
                }
            }
        
    }
    
    @IBAction func bannerOneAction(_ sender: Any) {
            let objStartWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartWebViewController") as! StartWebViewController
            self.navigationController?.pushViewController(objStartWebViewController, animated: true)
    }
    
    @IBAction func bannerTwoAction(_ sender: Any) {
        isPurchased()
    }
    
    @IBAction func bannerThreeAction(_ sender: Any) {
    }
    
    @IBAction func bannerFourAction(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationItem.backButtonTitle = ""
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        AppUtility.lockOrientation(.portrait)
    }

}
extension UIViewController {
func setupBackButton() {
    let customBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = customBackButton
}}

