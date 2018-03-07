//
//  MapViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 07/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var mapView:GMSMapView?
    
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), camera: GMSCameraPosition.camera(withLatitude: 13.736717, longitude: 100.523186, zoom: 11))
        mapView?.settings.compassButton = true
        mapView?.settings.myLocationButton = true
        
//        so the mapView is of width 200, height 200 and its center is same as center of the self.view
        let center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                mapView?.center = center
        
        self.view.addSubview(mapView!)
        self.view.bringSubview(toFront: navigationBar)
        
        mapView?.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnToOverview(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            mapView?.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom:10.0)
            mapView?.settings.myLocationButton = true
    
            didFindMyLocation = true
        }
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView?.isMyLocationEnabled = true
        }
    }
}
