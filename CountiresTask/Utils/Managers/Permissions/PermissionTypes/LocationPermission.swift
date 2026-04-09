//
//  LocationPermission.swift
//  CountiresTask
//
//  Created by Ahmed Abdelraouf on 09/04/2026.
//

import Foundation
import CoreLocation

class LocationPermission: NSObject, PermissionTypeContract {
    var completionHandler: (AuthorizationStatus) -> Void = { _ in }
    private let locationManager: CLLocationManager = CLLocationManager()
    
    func requestPermission(completionHandler: @escaping (AuthorizationStatus) -> Void) {
        self.completionHandler = completionHandler
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func checkAuthorizationStatus(completionHandler: @escaping (AuthorizationStatus) -> Void) {
        switch locationManager.authorizationStatus {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            completionHandler(.authorized)

        case .denied, .restricted:
            completionHandler(.denied)

        case  .notDetermined:
            completionHandler(.notDetermined)
        default:
            completionHandler(.denied)
        }
    }
}


extension LocationPermission: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkAuthorizationStatus(completionHandler: completionHandler)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus(completionHandler: completionHandler)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus(completionHandler: completionHandler)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        checkAuthorizationStatus(completionHandler: completionHandler)
    }
}
