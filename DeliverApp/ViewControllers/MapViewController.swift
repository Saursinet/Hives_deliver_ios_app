//
//  MapViewController.swift
//  DeliverApp
//
//  Created by Florian Saurs on 07/03/2018.
//  Copyright © 2018 Florian Saurs. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

enum Location {
    case startLocation
    case destinationLocation
}

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var googleMaps: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var didFindMyLocation = false
    
    let currentLocationMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        let camera = GMSCameraPosition.camera(withLatitude: 14.062668, longitude: 100.60708, zoom: 15)
        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.isMyLocationEnabled = true
        self.googleMaps.settings.zoomGestures = true
        
        drawPath(startLocation: CLLocation(latitude: 14.062668, longitude: 100.60708), endLocation: CLLocation(latitude: 13.982064, longitude: 100.550993))
    }
    
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
    }
    
    //MARK: location manager delegates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        createMarker(titleMarker: "Last location", iconMarker: #imageLiteral(resourceName: "location"), latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
    }

    //MARK: mapview delegates
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMaps.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Coordiantes: \(coordinate)")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                // print route using Polyline
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.googleMaps
                }
                
                self.createMarker(titleMarker: "origin", iconMarker: #imageLiteral(resourceName: "location"), latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
                self.createMarker(titleMarker: "destination", iconMarker: #imageLiteral(resourceName: "location"), latitude: endLocation.coordinate.latitude, longitude: endLocation.coordinate.longitude)
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            googleMaps?.isMyLocationEnabled = true
        }
    }
}

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        )
        
        // set coordinate to text
        if locationSelected == .startLocation {
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        } else {
            locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        
        
        self.googleMaps.camera = camera
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
