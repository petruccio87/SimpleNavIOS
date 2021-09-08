//
//  LocatonModel.swift
//  SimpleNavIOS
//
//  Created by admin on 03.09.2021.
//

import Foundation
import MapKit

struct LocationDataModel {
    var lastSeenLocation: CLLocation?
    var currentPlacemark: CLPlacemark?
    var authorizationStatus: CLAuthorizationStatus
    
    init(){
        authorizationStatus = .notDetermined
    }
}
