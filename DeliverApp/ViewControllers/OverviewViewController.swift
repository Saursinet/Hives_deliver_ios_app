//
//  OverviewViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 06/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit
import CoreLocation

class OverviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var circleGraphView: CircleGraphView!
    @IBOutlet weak var percentageNumberLabel: UILabel!
    
    @IBOutlet weak var stopTableView: UITableView!
    
    @IBOutlet weak var numberStopsLabel: UILabel!
    @IBOutlet weak var numberStopsRemainingLabel: UILabel!
    @IBOutlet weak var numberStopCompletedLabel: UILabel!
    
    var data: [Stop] = []
    var nbDelivered: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopTableView.dataSource = self
        stopTableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        Helper.setValidateDesignToButton(button: finishButton)
        circleGraphView.arcWidth = 15.0
        circleGraphView.endArc = 0.0
        
        let backgroundTrackColor = UIColor(white: 0.15, alpha: 1.0)
        circleGraphView.arcBackgroundColor = backgroundTrackColor
        circleGraphView.arcColor = UIColor(red: 131/255, green: 192/255, blue: 81/255, alpha: 1)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        numberStopsLabel.text = String(data.count) + " Stops"
        nbDelivered = 0
        var nbNonDelivered: Int = 0
        
        data.forEach { stop in
            if (stop.delivered) {
                nbDelivered = nbDelivered + 1
            } else {
                nbNonDelivered = nbNonDelivered + 1
            }
        }
        numberStopCompletedLabel.text = String(nbNonDelivered) + " Drops remaining"
        numberStopsRemainingLabel.text = String(nbDelivered) + " Completed"
        
        percentageNumberLabel.text = String(format:" %.0f %%", CGFloat(nbDelivered) / CGFloat(data.count) * 100)
        circleGraphView.endArc = CGFloat(nbDelivered) / CGFloat(data.count)

        stopTableView.reloadData()
        if (nbDelivered == data.count) {
            let alertController = UIAlertController(title: "Route finished", message:
                "You just finished to deliver all stops on that route.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default ,handler: {
                (_)in
                self.performSegue(withIdentifier: "unwindToSearch", sender: self)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func slided(_ sender: UISlider) {
        circleGraphView.endArc = CGFloat(sender.value)
        percentageNumberLabel.text = String(format:" %.0f %%", sender.value * 100)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "goToMap" {
                if (nbDelivered == data.count) {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToMap") {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
            navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-arrow")
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-arrow")
            navigationController?.navigationBar.tintColor = UIColor.black
            let destinationVC = segue.destination as! MapViewController
            var stop: Stop?
            var found: Bool = false
            for stopTmp in data {
                if !stopTmp.delivered && !found {
                    stop = stopTmp
                    found = true
                }
            }
            destinationVC.locationEnd = CLLocation(latitude: (stop?.latitude)!, longitude: (stop?.longitude)!)
        }
    }
    
    func childViewControllerResponse(param: Stop)
    {
        data.forEach { stop in
            if (stop.id == param.id) {
                stop.delivered = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!data[indexPath.row].delivered) {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StopViewController") as? StopViewController {
                viewController.stop = data[indexPath.row]
                viewController.delegate = self
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! StopTableViewCell
        
        cell.nameLabel.text = data[indexPath.row].name
        if (data[indexPath.row].delivered) {
            cell.doneButton.isHidden = true
        }
        
        return cell
    }
}
