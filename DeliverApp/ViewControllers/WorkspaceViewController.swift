//
//  WorkspaceViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 03/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

public extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = -5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        layer.add(animation, forKey: "shake")
    }
}

class WorkspaceViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var workspaceTextField: UITextField!
    @IBOutlet weak var errorWorkspaceLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        workspaceTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        workspaceTextField.delegate = self
        
        checkIfTokenExist()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        workspaceTextField.becomeFirstResponder()
        workspaceTextField.enablesReturnKeyAutomatically = false
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if (workspaceTextField.text?.count != 0) {
            nextButton.tintColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
            workspaceTextField.enablesReturnKeyAutomatically = true
        } else {
            nextButton.tintColor = UIColor.lightGray
            workspaceTextField.enablesReturnKeyAutomatically = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (workspaceTextField.text?.count != 0) {
            performSegue(withIdentifier: "goToUsernameView", sender: nil)
        } else {
            workspaceTextField.shake()
            errorWorkspaceLabel.text = "That workspace doesn't exist, try again."
            errorWorkspaceLabel.isHidden = false
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "goToUsernameView" {
                if (workspaceTextField.text?.count == 0) {
                    workspaceTextField.shake()
                    errorWorkspaceLabel.text = "That workspace doesn't exist, try again."
                    errorWorkspaceLabel.isHidden = false
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
        
        let destinationVC = segue.destination as! EmailAddressViewController
        destinationVC.domainName = (workspaceTextField as! ConcatTextField).typedText
    }
    
    func checkIfTokenExist() {
        let currentLevelKey = "Token"
        
        if userPreferences.exist(key: currentLevelKey) {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}

