//
//  Helper.swift
//  DeliverApp
//
//  Created by Florian Saurs on 28/02/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static func setTextFieldInvisibleWithBottomLine(textField: UITextField, color: CGColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, textField.frame.height - 1, textField.frame.width, 1.0)
        bottomLine.backgroundColor = color
        textField.layer.addSublayer(bottomLine)
    }
        
    static func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    static func setValidateDesignToButton(button: UIButton) {
//        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20.0
//        button.layer.borderColor = UIColor.black.cgColor
    }
    
    static func storeToken(json: [String: AnyObject]) {
        for _ in json {
            if let token = json["token"] {
                if !userPreferences.save(token: token as! String, key: "Token") {
                    print("Error saving access Token")
                }
            }
        }
    }
}
