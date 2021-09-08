//
//  LocatioVieModel.swift
//  SimpleNavIOS
//
//  Created by admin on 02.09.2021.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var lastSeenLocation: CLLocation?
    var currentPlacemark: CLPlacemark?
    
    private static func createDataModel() -> LocationDataModel {
        LocationDataModel()
    }
    
    @Published private var dataModel = createDataModel()
//    var isUserTracking: Bool {
//        dataModel.isUserTracking
//    }
//    @Published var userTrackingMode: MapUserTrackingMode = .follow
//    var userTrackingMode: MapUserTrackingMode {
//        get {
//            isUserTracking ? .follow : .none
//        }
//        set {
//
//        }
//    }
        
    private let locationManager: CLLocationManager
    
    override init() {
        print("init func")
        locationManager = CLLocationManager()
        super.init()
        dataModel.authorizationStatus = locationManager.authorizationStatus
        authorizationStatus = dataModel.authorizationStatus
        lastSeenLocation = dataModel.lastSeenLocation
        currentPlacemark = dataModel.currentPlacemark
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Location status: \(manager.authorizationStatus.rawValue)")
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        lastSeenLocation = location
        fetchCountryAndCity(for: locations.first)
    }

    func fetchCountryAndCity(for location: CLLocation?) {
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.dataModel.currentPlacemark = placemarks?.first
//            if let myPlacemark = placemarks?.first {
//                print("My Placemark: \(myPlacemark.locality ?? String("no locality")) \(myPlacemark.subLocality ?? String("no subLocality")) \(myPlacemark.thoroughfare ?? String("no thoroughfare")) \(myPlacemark.subThoroughfare ?? String("no subThorougghfare"))")
//            }
        }
    }
        
    
}
