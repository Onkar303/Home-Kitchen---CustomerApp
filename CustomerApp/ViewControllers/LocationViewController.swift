//
//  LocationViewController.swift
//  CustomerApp
//
//  Created by user173285 on 11/22/20.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let distanceRange: CLLocationDistance = 100
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachDelegate()
       locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManagerDidChangeAuthorization(locationManager)
        validateLocationServices()
    }
    
   
    
    
    // Function for Delegate
    
    func attachDelegate(){
        mapView.delegate = self
    }
    
    
    
    func setupLocationManager() {
       locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func validateLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
         locationManagerDidChangeAuthorization(locationManager)
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    //User Location
    func centerUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: distanceRange, longitudinalMeters: distanceRange)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Location Authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus{
        
        case .authorizedWhenInUse:
                locationTracking()
                print("authorized")
                
        case .denied:
            break
        case .authorizedAlways:
            break
      default:
                break
                
            }
    }
    
    
//    // Function: To get directions
//    func getDirections(){
//        guard let location = locationManager.location?.coordinate else{
//        return
//        }
//
//    }
    
    // Function: Go Tap button to get directions
//
//    @IBAction func goButtonTapped(_ sender: UIButton){
//
//    }
//
    
    // Function for tracking user location
    func locationTracking(){
        mapView.showsUserLocation = true
        centerUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
    
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension LocationViewController{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: distanceRange, longitudinalMeters: distanceRange)
        mapView.setRegion(region, animated: true)
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManagerDidChangeAuthorization(locationManager)
        
    }
    
   
     
    }


extension LocationViewController{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        guard let previousLocation = self.previousLocation else {return}
        
        guard center.distance(from: previousLocation) > 50 else {return}
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center){ [weak self] (placemarks, error)in
            
            guard let self = self else{return}
            
            if let _ = error{
                // For Alert if we need any
                return
            }
            
            guard let placemark = placemarks?.first else{
                // For Alert if we need any
                return
            }
            
            let streetNo = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            //let locality = placemark.subLocality
            let postalcode = placemark.postalCode ?? ""
            //let region = placemark.region
            
            DispatchQueue.main.async {
                self.address.text = "\(streetNo) \(streetName) \(postalcode)"
            }
            }
        }
    
}
