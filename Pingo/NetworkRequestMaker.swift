//
//  NetworkRequestMaker.swift
//  PaketStop
//
//  Created by Israr Ahmad on 10/4/20.
//  Copyright © 2020 paras. All rights reserved.
//

import Foundation
public class NetworkRequestMaker{


    public static func makePostRequest(url:String, urlParameters:String,completionHandler:@escaping (Data) -> Void){
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        let mData = urlParameters.data(using: .utf8)
        let task = URLSession.shared.uploadTask(with: request, from: mData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if error == nil {
                completionHandler(data!)
                //print(receivedData!)
            }
        }
        task.resume()
    }

    public static func getUrlParameters2(urlParameters: [String: String])->String{
        var query = ""
        urlParameters.forEach { key, value in
            query = query + "\(key)=\(value)&"
        }
        
        return query
    }
}
