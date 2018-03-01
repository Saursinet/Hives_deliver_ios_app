//
//  ViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 28/02/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let textFieldUnderlineColor = UIColor.init(red:55/255.0, green:61/255.0, blue:66/255.0, alpha: 1.0).cgColor
        Helper.setTextFieldInvisibleWithBottomLine(textField: usernameTextField, color: textFieldUnderlineColor)
        Helper.setTextFieldInvisibleWithBottomLine(textField: passwordTextField, color: textFieldUnderlineColor)
        Helper.setValidateDesignToButton(button: loginButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_sender: Any) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: Any) {
        if (usernameTextField.text?.count == 0 || passwordTextField.text?.count == 0) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Sign in failed", message: "Mail address or password is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Sign in", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return ;
        }
        loadMainView()
//        DataController.login(email: usernameTextField.text!, password: passwordTextField.text!) { (success, message) -> () in
//            if success {
//                self.loadMainView()
//            } else {
//                DispatchQueue.main.async {
//                    let alert = UIAlertController(title: "Sign in failed", message: "Mail address or password is incorrect.", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Sign in", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
    }
    
    func loadMainView() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}

