//
//  StopViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 07/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit
import GoogleMaps

protocol ChildViewControllerDelegate {
    func childViewControllerResponse(stop:Stop)
}

class StopViewController: UIViewController {

    var stop: Stop?
    
    var delegate: OverviewViewController?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var deliveredButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = stop?.name
        
        addressLabel.numberOfLines = 0
        
        Helper.setValidateDesignToButton(button: deliveredButton)
        // Do any additional setup after loading the view.
        
        findNamePlace()
    }
    
    func findNamePlace() {
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: (stop?.latitude)!, longitude: (stop?.longitude)!)) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.addressLabel.text = lines.joined(separator: "\n")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deliveredStop(_ sender: Any) {
        self.delegate?.childViewControllerResponse(param: stop!)
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
