//
//  LocatonModel.swift
//  SimpleNavIOS
//
//  Created by admin on 03.09.2021.
//

import Foundation
import MapKit

struct LocationDataModel {
//    var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402) , span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    var mapRegion: MKCoordinateRegion?
    var lastSeenLocation: CLLocation?
    var currentPlacemark: CLPlacemark?
    var authorizationStatus: CLAuthorizationStatus
    
    init(){
//        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402) , span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        authorizationStatus = .notDetermined
    }
}
