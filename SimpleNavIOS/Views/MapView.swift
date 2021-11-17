//
//  MapView.swift
//  MapSwiftUI
//
//  Created by admin on 19.10.2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel

//    let landmarks : [Landmark]
    @State private var userTrackingMode: MKUserTrackingMode = .none
    
    var isUserTracking: Bool {
        get {
            if userTrackingMode == .follow || userTrackingMode == .followWithHeading {
                return true
            } else {
                return false
            }
        }
    }
    
    func toggleTrack() {
//        userTrackingMode = .follow
        if userTrackingMode == .follow {
            userTrackingMode = .none
        } else {
            userTrackingMode = .follow
        }
    }
    
    var body: some View {
        MyMKMapView(landmarks: locationViewModel.destPins, myuserTrackingMode: $userTrackingMode)
            .gesture(DragGesture().onChanged(){ _ in
                userTrackingMode = .none
            })
            .edgesIgnoringSafeArea(.all)
        VStack{
            Spacer()
            HStack{
                Spacer()
                VStack{
//                    CircleButton(iconName: "minus.circle") { map.zoomOut() }
//                    CircleButton(iconName: "plus.circle") { map.zoomIn() }
                    CircleButton(iconName: "location.circle") { toggleTrack() }
                        .opacity(isUserTracking ? 0.3 : 1)
                }.padding(.trailing, 20)
            }.padding(.bottom, 150)
        }
    }
}


struct MyMKMapView: UIViewRepresentable {
    
    struct Holder {
        var trackingUserLocation = true
    }
    let landmarks: [Landmark]
    @Binding var myuserTrackingMode: MKUserTrackingMode

    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.showsScale = true
        map.delegate = context.coordinator
        return map
    }
    
    func makeCoordinator() -> MapCoordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateAnnotations(from: mapView)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        if landmarks.first?.coordinate != mapView.annotations.first?.coordinate {
            mapView.removeAnnotations(mapView.annotations)
            if let landmark = landmarks.first {
                let annotation = LandmarkAnnotation.init(landmark: landmark)
                mapView.addAnnotation(annotation)
            mapView.fitAllMarkers(shouldIncludeCurrentLocation: true)
            }
        }
//        mapView.removeAnnotations(mapView.annotations)
//        let annotations = landmarks.map(LandmarkAnnotation.init)
//        mapView.addAnnotations(annotations)
    }
}


final class MapCoordinator: NSObject, MKMapViewDelegate {
    
    var control : MyMKMapView
    
    init(_ control: MyMKMapView) {
        self.control = control
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotationView = views.first {
            if let annotation = annotationView.annotation {
                if annotation is MKUserLocation {
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if mapView.region.center != userLocation.coordinate && self.control.myuserTrackingMode != .none {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
//            mapView.setCenter(userLocation.coordinate, animated: true)
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("select annotation \(String(describing: view.annotation?.title ?? "no annotation"))")
    }
}

extension MKMapView {
    func fitAllMarkers(shouldIncludeCurrentLocation: Bool) {

        if !shouldIncludeCurrentLocation
        {
            showAnnotations(annotations, animated: true)
        }
        else
        {
            var zoomRect = MKMapRect.null

            let point = MKMapPoint(userLocation.coordinate)
            let pointRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            zoomRect = zoomRect.union(pointRect)

            for annotation in annotations {

                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)

                if (zoomRect.isNull) {
                    zoomRect = pointRect
                } else {
                    zoomRect = zoomRect.union(pointRect)
                }
            }

            setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 30, left: 20, bottom: 120, right: 20), animated: true)
        }
    }
}





extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.latitude == rhs.latitude, lhs.longitude == rhs.longitude { return true }
        else { return false }
    }
}






////
////  MapView.swift
////  SimpleNavIOS
////
////  Created by admin on 08.09.2021.
////
//
//import SwiftUI
//import MapKit
//
//struct MapView: View {
//    @EnvironmentObject var locationViewModel: LocationViewModel
//    @State private var userTrackingMode: MKUserTrackingMode = .none
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(
//            latitude: 37.759351,
//            longitude: -122.446913
//        ),
//        span: MKCoordinateSpan(
//            latitudeDelta: 10,
//            longitudeDelta: 10
//        )
//    )
//
//    var isUserTracking: Bool {
//        get {
//            if userTrackingMode == .follow || userTrackingMode == .followWithHeading {
//                return true
//            } else {
//                return false
//            }
//        }
//    }
//
//    func toggleTrack() {
//        if userTrackingMode == .followWithHeading {
//            userTrackingMode = .none
//        } else {
//            userTrackingMode = .followWithHeading
//        }
//    }
//    func zoomIn() {
//        region.span = MKCoordinateSpan(
//            latitudeDelta: region.span.latitudeDelta * 0.7,
//            longitudeDelta: region.span.longitudeDelta * 0.7
//        )
//        print ("ZoomIn \(region.span.latitudeDelta) : \(region.span.longitudeDelta)")
//    }
//    func zoomOut() {
//        if (region.span.latitudeDelta < 100 || region.span.longitudeDelta < 100) {
//            region.span = MKCoordinateSpan(
//                latitudeDelta: region.span.latitudeDelta / 0.7,
//                longitudeDelta: region.span.longitudeDelta / 0.7
//            )
//        }
//        print ("ZoomOut \(region.span.latitudeDelta) : \(region.span.longitudeDelta)")
//    }
//
//    var body: some View {
//
//        ZStack {
//            MyMKMapView(region: $region, userTrackingMode: $userTrackingMode, annotations: locationViewModel.destPins)
//                .edgesIgnoringSafeArea(.all)
////            #if DEBUG
////            Text("lat: \(region.center.latitude) lng: \(region.center.longitude) zoom: \(region.span.latitudeDelta) Track: \(userTrackingMode.rawValue)")
////            #endif
//            VStack{
//                Spacer()
//                HStack{
//                    Spacer()
//                    VStack{
//                        CircleButton(iconName: "minus.circle") { zoomOut() }
//                        CircleButton(iconName: "plus.circle") { zoomIn() }
//                        CircleButton(iconName: "location.circle") { toggleTrack() }
//                            .opacity(isUserTracking ? 1 : 0.6)
//                    }.padding(.trailing, 20)
//                }.padding(.bottom, 100)
//            }
//        }
//    }
//}
//
//struct CircleButton: View {
//    var action: () -> Void
//    var iconName: String
//
//    init(iconName: String, _ action: @escaping () -> Void) {
//        self.action = action
//        self.iconName = iconName
//    }
//
//    var body: some View {
//        Button(action: {
//            withAnimation {
//                action()
//            }
//        }) {
//            Image(systemName: iconName)
//        }
//        .padding(10)
//        .background(Color.black.opacity(0.75))
//        .foregroundColor(.white)
//        .font(.title)
//        .clipShape(Circle())
//    }
//}
//
//
//
//
//
//
//
//
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
