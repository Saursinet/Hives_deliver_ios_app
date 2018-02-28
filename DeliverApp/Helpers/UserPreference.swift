//
//  UserPreference.swift
//  DeliverApp
//
//  Created by Florian Saurs on 28/02/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import Foundation

class userPreferences {
    
    static func save(token: String, key: String) -> Bool {
        let preferences = UserDefaults.standard
        preferences.set(token, forKey: key)
        return preferences.synchronize()
    }
    
    static func get(key: String) -> String {
        let preferences = UserDefaults.standard
        if exist(key: key) {
            return preferences.object(forKey: key) as! String
        }
        return ""
    }
    
    static func exist(key: String) -> Bool {
        let preferences = UserDefaults.standard
        return preferences.object(forKey: key) != nil
    }
    
    static func remove(key: String) -> Void {
        let preferences = UserDefaults.standard
        preferences.removeObject(forKey: key)
    }
}
