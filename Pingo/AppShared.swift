//
//  AppShared.swift
//  Pingo
//
//  Created by Abhishek Dubey on 09/09/21.
//

import Foundation

class AppShared {
    static let shared = AppShared()
    private init() {}
    var transactionReceipt: String?
    var deviceID: String?
    var purchased: Int?
    var id: Int?
}
