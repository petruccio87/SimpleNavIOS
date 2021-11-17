//
//  Landmark.swift
//  MapSwiftUI
//
//  Created by admin on 27.10.2021.
//

import Foundation
import MapKit

struct Landmark: Hashable {
    
    let placemark: MKPlacemark
    
    var id: UUID {
        return UUID()
    }
    var name: String {
        return placemark.name ?? ""
    }
    var title: String {
        return placemark.title ?? ""
    }
    var coordinate: CLLocationCoordinate2D {
        return placemark.coordinate
    }
}
