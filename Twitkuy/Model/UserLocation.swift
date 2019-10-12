//
//  LocationManager.swift
//  Twitkuy
//
//  Created by Willa on 03/10/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    static let instance = UserLocation()
    
    var locationManager = CLLocationManager()
    var delegate:UserLocationDelegateProtocol!
    var userLocation: CLLocation?
    
   
    
    
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    func setupLocationManager(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.horizontalAccuracy > 0{
                locationManager.stopUpdatingLocation()
                locationManager.delegate = nil
                
                self.delegate?.lastUserLocation(latitude: location.coordinate.latitude, longtitude: location.coordinate.longitude)
                
                self.userLocation = location
            }
        }
    }
    
    func calcDistanceTo(lat: Double, long: Double) -> Double{
        let latitude = CLLocationDegrees(exactly: lat)
        let longtitude = CLLocationDegrees(exactly: long)
        let location =  CLLocation(latitude: latitude!, longitude: longtitude!)
        let distance = Double(self.userLocation?.distance(from: location) ?? 0.0)
        
        return distance / 1000
    }
    
    
}


protocol UserLocationDelegateProtocol {
    func lastUserLocation(latitude: Double, longtitude: Double)

}

