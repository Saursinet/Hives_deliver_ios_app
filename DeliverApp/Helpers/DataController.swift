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
        var request = URLRequest(url: URL(string: "http://212.47.242.70:9000/v1/" + path)!)
        
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
        
        if token != "" {
            request.setValue(token, forHTTPHeaderField: "x-access-token")
        }
        
        return request
    }
    
    static func login(workspace: String, email: String, password: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let loginObject = ["workspace": workspace, "email": email, "password": password]
        
        post(request: clientURLRequest(path: "signin", params: loginObject)) { (success, json, response) -> () in
            DispatchQueue.main.async { () -> Void in
                if success {
                    print(json!)
                    userPreferences.storeToken(json: json as! [String : AnyObject])
                    completion(true, nil)
                } else {
                    completion(false, String(describing: response))
                }
            }
        }
    }
    
    static func findRoute(route: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        token = userPreferences.get(key: "Token")
        
        get(request: clientURLRequest(path: "direction/" + route)) { (success, json, response) -> () in
            DispatchQueue.main.async { () -> Void in
                token = ""
                if success {
                    print(json!)
                    completion(true, nil)
                } else {
                    completion(false, String(describing: response))
                }
            }
        }
    }
    
    static func findStops(completion: @escaping (_ success: Bool, _ message: String?, _ data: NSArray) -> ()) {
        token = userPreferences.get(key: "Token")
        
        get(request: clientURLRequest(path: "stops")) { (success, json, response) -> () in
            DispatchQueue.main.async { () -> Void in
                token = ""
                if success {
                    print(json!)
                    completion(true, nil, (json as? NSArray)!)
                } else {
                    completion(false, nil, NSArray())
                }
            }
        }
    }
}
