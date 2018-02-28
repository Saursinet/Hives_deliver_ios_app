//
//  DataController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 28/02/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import Foundation

class DataController {
    
    static var token = ""
    
    private static func dataTask(request: URLRequest, method: String, completion: @escaping (_ success: Bool, _ json: AnyObject?, _ response: URLResponse?) -> ()) {
        
        var request = request
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let httpStatus = response as? HTTPURLResponse, 200...299 ~= httpStatus.statusCode {
                    completion(true, json as AnyObject, response)
                } else {
                    completion(false, json as AnyObject, response)
                }
            } else {
                print("error")
            }
        };
        task.resume()
    }
    
    private static func post(request: URLRequest, completion: @escaping (_ success: Bool, _ json: AnyObject?, _ response: URLResponse?) -> ()) {
        dataTask(request: request, method: "POST", completion: completion)
    }
    
    private static func put(request: URLRequest, completion: @escaping (_ success: Bool, _ json: AnyObject?, _ response: URLResponse?) -> ()) {
        dataTask(request: request, method: "PUT", completion: completion)
    }
    
    private static func get(request: URLRequest, completion: @escaping (_ success: Bool, _ json: AnyObject?, _ response: URLResponse?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    private static func delete(request: URLRequest, completion: @escaping (_ success: Bool, _ json: AnyObject?, _ response: URLResponse?) -> ()) {
        dataTask(request: request, method: "DELETE", completion: completion)
    }
    
    private static func clientURLRequest(path: String, params: Dictionary<String, Any>? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: "http://51.15.204.196:6969/" + path)!)
        
        if params != nil {
            do {
                let tmp = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
                request.httpBody = tmp
                print(tmp)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if token != "" {
            request.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        
        return request
    }
    
    static func login(email: String, password: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let loginObject = ["email": email, "password": password]
        
        post(request: clientURLRequest(path: "api/signin", params: loginObject)) { (success, json, response) -> () in
            DispatchQueue.main.async { () -> Void in
                if success {
                    print("success")
                    print(json!)
                    Helper.storeToken(json: json as! [String : AnyObject])
                    completion(true, nil)
                } else {
                    print("error")
                    completion(false, String(describing: response))
                }
            }
        }
    }
}
