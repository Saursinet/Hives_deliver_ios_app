//
//  CircleGraphView.swift
//  DeliverApp
//
//  Created by Florian Saurs on 06/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit

class CircleGraphView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var endArc:CGFloat = 0.0 {   // in range of 0.0 to 1.0
        didSet {
            setNeedsDisplay()
        }
    }
    var lastEndArc:CGFloat = 0.0
    var arcWidth:CGFloat = 5.0
    var arcColor = UIColor.yellow
    var arcBackgroundColor = UIColor.black
    
    var timeBetweenDraw:CFTimeInterval = 0.01
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        Timer.scheduledTimer(timeInterval: timeBetweenDraw, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let fullCircle = 2.0 * CGFloat(Double.pi)
        let start:CGFloat = -0.25 * fullCircle
        let end:CGFloat = lastEndArc * fullCircle + start
        
        var centerPoint = CGPoint(x: rect.midX, y: rect.midY)

        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if rect.width > rect.height {
            radius = (rect.width - arcWidth) / 2.0
        } else{
            radius = (rect.height - arcWidth) / 2.0
        }
        
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        
        //set colorspace
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        //set line attributes
        context!.setLineWidth(arcWidth)
        context!.setLineCap(CGLineCap.round)
        
        //make the circle background
        context!.setStrokeColor(arcBackgroundColor.cgColor)
        context!.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: fullCircle, clockwise: false)
        context!.strokePath()
        
        context!.setLineWidth(arcWidth * 0.8)
        context!.setStrokeColor(arcColor.cgColor)
        context!.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        context!.strokePath()
    }

    @objc func updateTimer() {
        if lastEndArc < endArc {
            lastEndArc += 0.01
            setNeedsDisplay()
        }
    }
}
