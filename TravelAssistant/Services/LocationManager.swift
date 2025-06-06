//
//  LocationManager.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var locationError: String?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update only when location changes by 10 meters
        locationStatus = locationManager.authorizationStatus
        
        print("LocationManager initialized, current status: \(locationManager.authorizationStatus.rawValue)")
    }
    
    func requestLocationPermission() {
        print("Requesting location permission, current status: \(locationManager.authorizationStatus.rawValue)")
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("Permission not determined, requesting when in use authorization")
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("Permission denied or restricted")
            DispatchQueue.main.async {
                self.locationError = "Location permission denied. Please enable Location Services in Settings."
            }
        case .authorizedWhenInUse, .authorizedAlways:
            print("Permission granted, starting location updates")
            startLocationUpdates()
        @unknown default:
            print("Unknown authorization status")
            break
        }
    }
    
    private func startLocationUpdates() {
        guard locationManager.authorizationStatus == .authorizedWhenInUse || 
              locationManager.authorizationStatus == .authorizedAlways else {
            print("Cannot start location updates: permission not granted")
            return
        }
        
        print("Starting location updates")
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        print("Stopping location updates")
        locationManager.stopUpdatingLocation()
    }
    
    func forceLocationUpdate() {
        print("Force requesting location update")
        guard locationManager.authorizationStatus == .authorizedWhenInUse || 
              locationManager.authorizationStatus == .authorizedAlways else {
            print("Cannot force location update: permission not granted")
            return
        }
        
        // Force request a one-time location update
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        print("Location updated: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        
        // Only update when the new location differs significantly from the current one
        if let currentLocation = location {
            let distance = newLocation.distance(from: currentLocation)
            if distance < 10 { // Ignore changes within 10 meters
                return
            }
        }
        
        DispatchQueue.main.async {
            self.location = newLocation
            self.locationError = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.locationError = "Location error: \(error.localizedDescription)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to: \(status.rawValue)")
        
        DispatchQueue.main.async {
            self.locationStatus = status
            
            switch status {
            case .notDetermined:
                print("Status: Not determined")
                break
            case .denied, .restricted:
                print("Status: Denied or restricted")
                self.locationError = "Location permission denied. Please enable Location Services in Settings."
                self.stopLocationUpdates()
            case .authorizedWhenInUse, .authorizedAlways:
                print("Status: Authorized, starting location updates")
                self.locationError = nil
                self.startLocationUpdates()
            @unknown default:
                print("Status: Unknown")
                break
            }
        }
    }
} 