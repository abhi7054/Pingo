//
//  AppPrefsManager.swift
//  PastZero
//
//  Created by Sunil Zalavadiya on 7/28/16.
//  Copyright © 2016 Sunil Zalavadiya. All rights reserved.
//

import UIKit
import CoreLocation
// swiftlint:disable all
class AppPrefsManager: NSObject {
    
    static let sharedInstance = AppPrefsManager()
    let SubscriptionDetails = "SubscriptionDetails"
    func setDataToPreference(data: AnyObject, forKey key: String) {
        do {
            var archivedData = Data()
            if #available(iOS 11.0, *) {
                archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            } else {
                archivedData = NSKeyedArchiver.archivedData(withRootObject: data)
            }
            UserDefaults.standard.set(archivedData, forKey: key)
            UserDefaults.standard.synchronize()
        }
        catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func getDataFromPreference(key: String) -> AnyObject? {
        let archivedData = UserDefaults.standard.object(forKey: key)
        if(archivedData != nil) {
            do {
                var unArchivedData: Any?
                if #available(iOS 11.0, *) {
                    unArchivedData =  try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(archivedData as! Data) as AnyObject
                } else {
                    unArchivedData = NSKeyedUnarchiver.unarchiveObject(with: archivedData as! Data) as AnyObject
                }
                return unArchivedData as AnyObject
            } catch {
                print("Unexpected error: \(error).")
            }
        }
        return nil
    }
    
    func removeDataFromPreference(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func isKeyExistInPreference(key: String) -> Bool {
        if(UserDefaults.standard.object(forKey: key) == nil) {
            return false
        }
        return true
    }
    
    func setSubscriptionDetails(obj: Int) {
           setDataToPreference(data: obj as AnyObject, forKey: SubscriptionDetails)
       }
       
    func getSubscriptionDetails() -> Int? {
        let strToken = getDataFromPreference(key: SubscriptionDetails)
        return strToken as? Int
    }
}

