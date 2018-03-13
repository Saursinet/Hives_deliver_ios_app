//
//  MainViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 28/02/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var routeNumberTextField: UITextField!
    
    @IBOutlet weak var routeNumberErrorLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.setValidateDesignToButton(button: searchButton)
        
        Helper.setValidateDesignToButton(button: scanButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
//        Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
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
    
//    @IBAction func showRouteOverview(_ sender: Any) {
//        if (routeNumberTextField.text?.count == 0) {
//            routeNumberTextField.shake()
//            routeNumberErrorLabel.text = "No route found."
//            routeNumberErrorLabel.isHidden = false
//            return ;
//        }
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OverviewViewController") as? OverviewViewController {
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//    }

    @IBAction func unwindToSearch(segue: UIStoryboardSegue) {}
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "goToRouteOverview" {
                if (routeNumberTextField.text?.count == 0) {
                    routeNumberTextField.shake()
                    routeNumberErrorLabel.text = "No route found."
                    routeNumberErrorLabel.isHidden = false
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
        
         let destinationVC = segue.destination as! OverviewViewController
        destinationVC.data =
            [Stop(id: 0, delivered: false, name: "7-11"),
        Stop(id: 1, delivered: false, name: "Starbucks"),
        Stop(id: 2, delivered: false, name: "Get Buy")]
    }
}
