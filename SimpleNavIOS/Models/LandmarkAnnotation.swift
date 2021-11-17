//
//  LandmarkAnnotation.swift
//  MapSwiftUI
//
//  Created by admin on 27.10.2021.
//

import MapKit
import UIKit

final class LandmarkAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    init(landmark: Landmark){
        title = landmark.name
        coordinate = landmark.coordinate
    }
}
