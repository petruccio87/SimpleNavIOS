//
//  LocatioVieModel.swift
//  SimpleNavIOS
//
//  Created by admin on 02.09.2021.
//

import Foundation
import CoreLocation
import MapKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var lastSeenLocation: CLLocation?
    var currentPlacemark: CLPlacemark?
    var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402) , span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    var isUserTracking = true
    
    private static func createDataModel() -> LocationDataModel {
        LocationDataModel()
    }
    
    @Published private var dataModel: LocationDataModel
        
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        dataModel = LocationViewModel.createDataModel()
        super.init()
        dataModel.authorizationStatus = locationManager.authorizationStatus
        authorizationStatus = dataModel.authorizationStatus
        lastSeenLocation = dataModel.lastSeenLocation
        currentPlacemark = dataModel.currentPlacemark
        mapRegion = dataModel.mapRegion ?? MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402) , span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
//        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402) , span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        
        
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
        lastSeenLocation = locations.first
        if let myLat = locations.first?.coordinate.latitude, let myLong = locations.first?.coordinate.longitude, isUserTracking {
            print("Coords: \(myLat), \(myLong)")
            mapRegion.center.latitude = myLat
            mapRegion.center.longitude = myLong
        }
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
    func zoomIn() {
//        userTrackingMode = .none
        if mapRegion.span.latitudeDelta > 10 { mapRegion.span.latitudeDelta -= 10 }
        if mapRegion.span.longitudeDelta > 10 { mapRegion.span.longitudeDelta -= 10 }
    }
    func zoomOut() {
//        userTrackingMode = .none
        if mapRegion.span.latitudeDelta < 90 { mapRegion.span.latitudeDelta += 10 }
        if mapRegion.span.longitudeDelta < 90 { mapRegion.span.longitudeDelta += 10 }
    }
    func userTrackingToggle() {
        isUserTracking.toggle()
        print("toggle")
        if isUserTracking {
            mapRegion.span.latitudeDelta = 0.01
            mapRegion.span.longitudeDelta = 0.01
        }
    }
    
    
}
