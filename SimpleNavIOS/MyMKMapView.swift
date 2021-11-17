////
////  MyMKMapView.swift
////  SimpleNavIOS
////
////  Created by admin on 10.09.2021.
////
//
//import SwiftUI
//import MapKit
//
//struct MyMKMapView: UIViewRepresentable {
//    @Binding var region: MKCoordinateRegion
//    @Binding var userTrackingMode: MKUserTrackingMode
//
//    var annotations: [MKPointAnnotation]
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        return mapView
//    }
//
//    func updateUIView(_ view: MKMapView, context: Context) {
//        if view.userTrackingMode != $userTrackingMode.wrappedValue {
//            view.setUserTrackingMode($userTrackingMode.wrappedValue, animated: true)
//                }
//        if annotations.first?.coordinate != view.annotations.first?.coordinate {
//            view.removeAnnotations(view.annotations)
//            view.addAnnotations(annotations)
//            view.fitAllMarkers(shouldIncludeCurrentLocation: true)
//        }
//        if view.region != region {
//            view.setRegion(region, animated: true)
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // this is our unique identifier for view reuse
//        let identifier = "Placemark"
//        // attempt to find a cell we can recycle
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        if annotationView == nil {
//            // we didn't find one; make a new one
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            // allow this to show pop up information
//            annotationView?.canShowCallout = true
//            // attach an information button to the view
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        } else {
//            // we have a view to reuse, so give it the new annotation
//            annotationView?.annotation = annotation
//        }
//        // whether it's a new view or a recycled one, send it back
//        return annotationView
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//
//        var parent: MyMKMapView
//
//        init(_ parent: MyMKMapView) {
//            self.parent = parent
//        }
//
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
////            print("viewDidChange")
////            parent.region = mapView.region
//        }
//    }
//
//}
//
//extension CLLocationCoordinate2D: Equatable {
//    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        if lhs.latitude == rhs.latitude, lhs.longitude == rhs.longitude { return true }
//        else { return false }
//    }
//}
//
//extension MKCoordinateSpan: Equatable {
//    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
//        if lhs.latitudeDelta == rhs.latitudeDelta, lhs.longitudeDelta == rhs.longitudeDelta { return true }
//        else { return false }
//    }
//}
//
//extension MKCoordinateRegion: Equatable {
//    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
//        if lhs.center == rhs.center, lhs.span == rhs.span { return true }
//        else { return false }
//    }
//}
//
//extension MKMapView
//{
//    func fitAllMarkers(shouldIncludeCurrentLocation: Bool) {
//
//        if !shouldIncludeCurrentLocation
//        {
//            showAnnotations(annotations, animated: true)
//        }
//        else
//        {
//            var zoomRect = MKMapRect.null
//
//            let point = MKMapPoint(userLocation.coordinate)
//            let pointRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
//            zoomRect = zoomRect.union(pointRect)
//
//            for annotation in annotations {
//
//                let annotationPoint = MKMapPoint(annotation.coordinate)
//                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
//
//                if (zoomRect.isNull) {
//                    zoomRect = pointRect
//                } else {
//                    zoomRect = zoomRect.union(pointRect)
//                }
//            }
//
//            setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
//        }
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
//
//
//extension MKPointAnnotation {
//    static var example: MKPointAnnotation {
//        let annotation = MKPointAnnotation()
//        annotation.title = "London"
//        annotation.subtitle = "Home to the 2012 Summer Olympics."
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
//        return annotation
//    }
//}
////struct MyMKMapView_Previews: PreviewProvider {
////    @EnvironmentObject var locationViewModel: LocationViewModel
////    static var previews: some View {
////        MyMKMapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), span: .constant(MKCoordinateSpan(
////            latitudeDelta: 10,
////            longitudeDelta: 10
////        )), userTrackingMode: .constant(.follow), annotations: [MKPointAnnotation.example])
////    }
////}
