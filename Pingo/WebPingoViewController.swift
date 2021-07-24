//
//  WebHelperViewController.swift
//

import UIKit
import WebKit
import JGProgressHUD
import TinyConstraints

class WebHelperViewController: UIViewController,WKNavigationDelegate,UIGestureRecognizerDelegate {
    
  
    let pageIndex=4
    var webView:WKWebView!
    var bounds = CGRect.zero
  
    

    
    

    
    func createWebView()
    {
        let prefs=WKPreferences()
      
    
        
        prefs.javaScriptEnabled=true
     
        var agent="Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:67.0) Gecko/201001001 Firefox/67.0" //firefox agent
        
        agent="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36" //chrome
      
        let conf=WKWebViewConfiguration()
        
        conf.preferences=prefs
        webView=WKWebView(frame: self.view.bounds, configuration: conf)
     
      
        if #available(iOS 9.0, *) {
            webView.customUserAgent=agent
        }else{
            UserDefaults.standard.register(defaults:[ "UserAgent":agent])
        }
        
        webView.navigationDelegate=self
        self.view=webView
   
        let url="https://web.whatsapp.com"// galeryLinks[pageIndex]
      
        let _u=URL(string: url)
        var req=URLRequest(url: _u!)
        
        req.setValue(agent, forHTTPHeaderField: "User-Agent")
        webView.load(req)
       
        webView.scrollView.showsHorizontalScrollIndicator=false
        webView.scrollView.showsVerticalScrollIndicator=false
        webView.reloadFromOrigin()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bounds = self.view.bounds
        let hud=JGProgressHUD()
        hud.show(in: self.view)
        createWebView()
        hud.dismiss()
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //SET VIEW
        
        AppUtility.lockOrientation(.all)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.determineMyDeviceOrientation()
//        }
        
        
        //SET NAVIGAITON AND TABBAR
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //SET NAVIGATION BAR
       
    }
    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft{
            return .landscapeLeft
        }
        else if orientation == .landscapeRight{
            return .landscapeRight
        }
        else{
            return .portrait
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }

    func determineMyDeviceOrientation()
       {
        let orientation = UIDevice.current.orientation
        if orientation == .landscapeLeft{
            print("Device is in landscape mode")
            AppUtility.lockOrientation(.landscapeLeft)
        }
        else if orientation == .landscapeRight{
            print("Device is in landscape mode")
            AppUtility.lockOrientation(.landscapeRight)
        }
        else{
            AppUtility.lockOrientation(.portrait)
        }
    }
   
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
  
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
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



