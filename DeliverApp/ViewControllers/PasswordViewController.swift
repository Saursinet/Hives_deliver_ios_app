//
//  PasswordViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 03/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    var domainName: String?
    var emailAddress: String?
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var eyeOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        passwordTextField.delegate = self
        
        passwordTextField.enablesReturnKeyAutomatically = false
        
        passwordErrorLabel.text = "Your password for \(String(describing: domainName!))"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passwordTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        executeRequestToLogin()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (passwordTextField.text?.count != 0) {
            nextButton.tintColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
            passwordLabel.isHidden = false
            passwordTextField.enablesReturnKeyAutomatically = true
        } else {
            nextButton.tintColor = UIColor.lightGray
            passwordLabel.isHidden = true
            passwordTextField.enablesReturnKeyAutomatically = false
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
        executeRequestToLogin()
    }
    
    func executeRequestToLogin() {
        if (passwordTextField.text?.count == 0) {
            passwordTextField.shake()
            passwordErrorLabel.text = "Incorrect password, try again."
        } else {
            DataController.login(workspace: domainName!, email: emailAddress!, password: passwordTextField.text!) { (success, message) -> () in
                if success {
                    print("success")
                    self.loadMainView()
                } else {
                    print(message ?? "")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Sign in failed", message: "L'addresse email ou le mot de passe ne correspond pas.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Sign in", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
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


