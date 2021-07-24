//
//  SettingsWebViewController.swift
//  Pingo
//
//  Created by Abhishek Dubey on 24/07/21.
//

import UIKit
import WebKit

class SettingsWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackButton()
        let url = URL(string: Constants.websiteURL)
        let urlRequest = URLRequest(url: url!)

        webView.load(urlRequest)
        self.title = Constants.title
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        
    }
    

}
