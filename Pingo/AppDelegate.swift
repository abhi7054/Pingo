//
//  AppDelegate.swift
//  Pingo
//
//  Created by Abhishek Dubey on 23/07/21.
//

import UIKit

struct CheckSubscriptionData: Codable {
    let purchase: Int
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.all
    var deviceID: String!
    
    var window: UIWindow?
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppUtility.lockOrientation(.portrait)
        
        checkUniqueID()
        
        getUserSubscription() { (json) in
            UserDefaults.standard.set(String(json.purchase), forKey: "purchased")
        }
        
        return true
    }
    func checkUniqueID() {
        if let udid = KeyChain.load(key: "uniqueID") {
            let uniqueID = String(data: udid, encoding: String.Encoding.utf8)
            print(uniqueID!)
            deviceID = uniqueID
            
        } else {
            let uniqueID = KeyChain.createUniqueID()
            let data = uniqueID.data(using: String.Encoding.utf8)
            let status = KeyChain.save(key: "uniqueID", data: data!)
            print(uniqueID)
            print(status)
            deviceID = uniqueID
        }
    }
    
    
    func getUserSubscription(completion: @escaping (CheckSubscriptionData)-> ()) {
        let urlString = "http://back-api.com/pingo/api/checkSubscription.php?deviceid=\(deviceID ?? "")"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, err in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let json: CheckSubscriptionData = try! decoder.decode(CheckSubscriptionData.self, from: data)
                        print(json)
                        completion(json)
                    }
                }
            }.resume()
        }
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
