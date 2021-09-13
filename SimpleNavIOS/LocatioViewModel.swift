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

//struct Destination: Identifiable {
//    let id = UUID()
//    let name: String
//    let location: CLLocation
//}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var lastSeenLocation: CLLocation?
    var currentPlacemark: CLPlacemark?
    var destAddress = ""
    @Published var destPins = [MKPointAnnotation]()
    @Published var distance = ""
    var isDistance: Bool {
        get {
            if distance == "" {
                return false
            } else {
                return true
            }
        }
    }
    @Published var heading: CLLocationDirection? = 0
    var bearing: CLLocationDirection?
    var bearingString: String {
        get {
            if let tmp = bearing {
                return String(tmp)
            } else {
                return ""
            }
        }
    }
    var directionToPoint: CLLocationDirection? {
        get {
            if heading != nil, bearing != nil {
                var result = bearing! - heading!
                if result >= 360 {
                    result -= 360
                }
                return -result
            } else {
                return nil
            }
        }
    }
    var directionToPointString: String {
        get {
            if let tmp = directionToPoint {
                return String(tmp)
            } else {
                return ""
            }
        }
    }

    
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
        locationManager.headingFilter = 5
        locationManager.startUpdatingHeading()
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
        getDistance()
        fetchCountryAndCity(for: locations.first)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading.trueHeading
        getBearing()
        print("Heading: \(newHeading.trueHeading)")
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
    
    func getDistance() {
        guard let location = lastSeenLocation  else { return }
        if !destPins.isEmpty {
            let destLocation = CLLocation(latitude: destPins.first!.coordinate.latitude, longitude: destPins.first!.coordinate.longitude)
            distance = String(Int(location.distance(from: destLocation )))
//            bearing = getBearingBetweenTwoPoints(from: location, to: destLocation)
//            print("distance: \(distance) meters")
        }
    }
    
    func getBearing() {
        guard let location = lastSeenLocation  else { return }
        if !destPins.isEmpty {
            let destLocation = CLLocation(latitude: destPins.first!.coordinate.latitude, longitude: destPins.first!.coordinate.longitude)
//            distance = String(Int(location.distance(from: destLocation )))
            bearing = getBearingBetweenTwoPoints(from: location, to: destLocation)
//            print("distance: \(distance) meters")
        }
    }
    
    func getCoordsByAddress() {
        let address = destAddress
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [self] (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    print("coords for address: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    let newDest = MKPointAnnotation()
                    newDest.coordinate = location.coordinate
                    newDest.title = address
//                    self.locations.append(newLocation)
                    
//                    let dest = Destination(name: address,
//                                           location: location)
                    destPins.removeAll()
                    destPins.append(newDest)
//                    completionHandler(location.coordinate, nil)
                    return
                }
                
            }
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints(from point1 : CLLocation, to point2 : CLLocation) -> CLLocationDirection {

        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }
}
