//
//  MainViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 28/02/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var routeNumberTextField: UITextField!
    
    @IBOutlet weak var routeNumberErrorLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.setValidateDesignToButton(button: searchButton)
        
        Helper.setValidateDesignToButton(button: scanButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        routeNumberTextField.delegate = self
        
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        requestSearchRoute()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard(_sender: Any) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScanViewController") as? ScanViewController {
            present(viewController, animated: true, completion: {})
        }
    }

    @IBAction func unwindToSearch(segue: UIStoryboardSegue) {}
    
    @IBAction func searchRoute(_ sender: Any) {
        requestSearchRoute()
    }
    
    func requestSearchRoute() {
        if (routeNumberTextField.text?.count == 0) {
            routeNumberTextField.shake()
            routeNumberErrorLabel.text = "No route found."
            routeNumberErrorLabel.isHidden = false
            return
        }

        DataController.findStops() { (success, message, json) -> () in
//        DataController.findRoute(route: routeNumberTextField.text!) { (success, message, json) -> () in
                if success {
                    var stopList = [Stop]()
                    for obj in json {
                        if let dict = obj as? NSDictionary {
                            if (dict.value(forKey: "ID") != nil && dict.value(forKey: "Name") != nil && (dict.value(forKey: "Latitude") != nil) && (dict.value(forKey: "Longitude") != nil)) {
                                stopList.append(Stop(id: dict.value(forKey: "ID") as! Int, delivered: false, name: dict.value(forKey: "Name") as! String, latitude: dict.value(forKey: "Latitude") as! Double, longitude: dict.value(forKey: "Longitude") as! Double))
                            }
                        }
                    }
                    if (stopList.count == 0) {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Couldn't load route", message: "Verify the route number", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        return
                    }
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OverviewViewController") as? OverviewViewController {
                        viewController.data = stopList
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                } else {
                    print(message ?? "")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Couldn't load route", message: "Verify the route number", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-arrow")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-arrow")
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @IBAction func logout(_ sender: Any) {
        userPreferences.remove(key: "Token")
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "RootViewController")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
