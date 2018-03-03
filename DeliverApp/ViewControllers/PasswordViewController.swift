//
//  PasswordViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 03/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var eyeOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        passwordTextField.isSecureTextEntry = true
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (passwordTextField.text?.count != 0) {
            nextButton.tintColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
            passwordLabel.isHidden = false
        } else {
            nextButton.tintColor = UIColor.lightGray
            passwordLabel.isHidden = true
        }
    }
    
    @objc func dismissKeyboard(_sender: Any) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearOrUnclearPassword(_ sender: Any) {
        if (eyeOpen) {
            eyeButton.setImage(#imageLiteral(resourceName: "closed-eye"), for: .normal)
            passwordTextField.isSecureTextEntry = true
            eyeOpen = false
        } else {
            eyeButton.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
            eyeOpen = true
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        loadMainView()
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


