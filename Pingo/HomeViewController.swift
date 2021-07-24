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
        
        setupBackButton()
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
        Constants.websiteURL = "http://pingo-app.online/"
        Constants.websiteURL = Constants.websiteURL+Constants.agreement
    }
    @IBAction func policyAction(_ sender: Any) {
        
        Constants.title = "Policy"
        Constants.websiteURL = "http://pingo-app.online/"
        Constants.websiteURL = Constants.websiteURL+Constants.policy
    }
    @IBAction func contact(_ sender: Any) {
        
        Constants.title = "Contact"
        Constants.websiteURL = "http://pingo-app.online/"
        Constants.websiteURL = Constants.websiteURL+Constants.contact
    }
    @IBAction func pingoWebsiteAction(_ sender: Any) {
        
        Constants.title = "Pingo"
        Constants.websiteURL = "http://pingo-app.online/"
    }
    
    @IBAction func bannerOneAction(_ sender: Any) {
    }
    
    @IBAction func bannerTwoAction(_ sender: Any) {
    }
    
    @IBAction func bannerThreeAction(_ sender: Any) {
    }
    
    @IBAction func bannerFourAction(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationItem.backButtonTitle = ""
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

}
extension UIViewController {
func setupBackButton() {
    let customBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = customBackButton
}}

