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
    var isDemoHeading = false
//    @Published var destPins = [MKPointAnnotation]()
    @Published var destPins = [Landmark]()
    @Published var routes = [MKRoute]()
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
    var oldHeading: CLLocationDirection = 0
    var rotationCount = 0
    var bearing: CLLocationDirection?
    var bearingString: String {
        get {
            if let tmp = bearing {
                return String(String(tmp).prefix(7))
            } else {
                return ""
            }
        }
    }
    var directionToPoint: CLLocationDirection? {
        get {
            if heading != nil, bearing != nil {
                let result = -heading! + bearing!
//                if result >= 360 {
//                    result -= 360
//                } else if result <= -360 {
//                    result += 360
//                }
                return result
            } else {
                return nil
            }
        }
    }
    var directionToPointString: String {
        get {
            if let tmp = directionToPoint {
                return String(String(tmp).prefix(7))
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
        DispatchQueue.main.async {
            guard let location = locations.first else { return }
            self.lastSeenLocation = location
            self.getDistance()
            self.fetchCountryAndCity(for: locations.first)
            if self.isDemoHeading {
                self.demoHeading()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.oldHeading = self.heading ?? 0
            self.heading = self.linearHeadingConverter(inHeading: newHeading.trueHeading)
            self.getBearing()
//            print("OldHeading: \(self.oldHeading) \n Heading: \(newHeading.trueHeading)")
//            print(self.heading! - self.oldHeading)
        }
    }
    
    func linearHeadingConverter(inHeading: CLLocationDirection) -> CLLocationDirection {
        var linearHeading = inHeading + Double(360 * rotationCount)
//        print("linear heading in: \(linearHeading)")

        if (linearHeading - self.oldHeading) > 300 {
            rotationCount -= 1
        }
        if (linearHeading - self.oldHeading) < -300 {
            rotationCount += 1
        }
        linearHeading = inHeading + Double(360 * rotationCount)

//        print("OldHeading: \(self.oldHeading) \n Heading: \(inHeading)")
//        print("rotation count: \(self.rotationCount)")
//        print("linear heading out: \(linearHeading)")
//        print(directionToPoint?.truncatingRemainder(dividingBy: 360))
        return linearHeading
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
/// demoHeading - for simulator, there is no heading
    func demoHeading() {
        guard let tmp = heading else { return }
        if tmp >= 360 {
            heading = 0
        } else {
            heading = tmp + 20
        }
        print(heading as Any)
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
//                    let newDest = Landmark(placemark: placemark)
//                    newDest.coordinate = location.coordinate
//                    newDest.title = address
//                    self.locations.append(newLocation)
                    
//                    let dest = Destination(name: address,
//                                           location: location)
                    let newDestPlacemark = MKPlacemark(placemark: placemark)
//                    newDestPlacemark.coordinate = location.coordinate
                    
                    destPins.removeAll()
                    destPins.append(Landmark(placemark: newDestPlacemark))
                    findRoute(on: .walking)
//                    completionHandler(location.coordinate, nil)
                    return
                }
                
            }
        }
    }
    
    func findRoute(on vehicle: MKDirectionsTransportType) {
        let request = MKDirections.Request()
        guard let startPointCoords = lastSeenLocation?.coordinate else { return }
        guard let endPointCoords = destPins.first?.coordinate else { return }
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startPointCoords))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endPointCoords))
        request.transportType = vehicle
        let directions = MKDirections(request: request)
        directions.calculate { [self] response, error in
            guard let route = response?.routes.first else { return }
            self.routes.removeAll()
            self.routes.append(route)
//            print("route: \(route.distance)")
//            mapView.addAnnotations([p1, p2])
//            mapView.addOverlay(route.polyline)
//            mapView.setVisibleMapRect(
//              route.polyline.boundingMapRect,
//              edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
//              animated: true)
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
