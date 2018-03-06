//
//  OverviewViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 06/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {
    
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var circleGraphView: CircleGraphView!
    @IBOutlet weak var percentageNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        Helper.setValidateDesignToButton(button: finishButton)
        circleGraphView.endArc = 0.4
        percentageNumberLabel.text = String(format:" %.0f %%", 40.0)
        circleGraphView.arcWidth = 35.0
        
        let backgroundTrackColor = UIColor(white: 0.15, alpha: 1.0)
        circleGraphView.arcBackgroundColor = backgroundTrackColor
        circleGraphView.arcColor = UIColor(red: 131/255, green: 192/255, blue: 81/255, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func slided(_ sender: UISlider) {
        circleGraphView.endArc = CGFloat(sender.value)
        percentageNumberLabel.text = String(format:" %.0f %%", sender.value * 100)
    }
}
