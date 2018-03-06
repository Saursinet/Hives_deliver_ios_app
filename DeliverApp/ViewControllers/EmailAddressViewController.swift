//
//  EmailAddressViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 03/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

class EmailAddressViewController: UIViewController, UITextFieldDelegate {
    
    var domainName: String?
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                
        emailTextField.delegate = self
        emailTextField.enablesReturnKeyAutomatically = false
        
        emailErrorLabel.numberOfLines = 0
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        emailTextField.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (emailTextField.text?.count != 0) {
            nextButton.tintColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
            emailLabel.isHidden = false
            emailTextField.enablesReturnKeyAutomatically = true
        } else {
            nextButton.tintColor = UIColor.lightGray
            emailLabel.isHidden = true
            emailTextField.enablesReturnKeyAutomatically = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (emailTextField.text?.count != 0) {
            performSegue(withIdentifier: "goToPasswordView", sender: nil)
        } else {
            emailTextField.shake()
            emailErrorLabel.text = "No account found. If you're sure you've signep up for \(String(describing: domainName!)), you can try another email address."
            emailErrorLabel.isHidden = false
        }
        
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "goToPasswordView" {
                if (emailTextField.text?.count == 0) {
                    emailTextField.shake()
                    emailErrorLabel.text = "No account found. If you're sure you've signep up for \(String(describing: domainName!)), you can try another email address."
                    emailErrorLabel.isHidden = false
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-arrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-arrow")
        navigationController?.navigationBar.tintColor = UIColor.black
        
        let destinationVC = segue.destination as! PasswordViewController
        destinationVC.domainName = domainName
        destinationVC.emailAddress = emailTextField.text!
    }
}

