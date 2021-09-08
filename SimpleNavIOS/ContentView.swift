//
//  ContentView.swift
//  SimpleNavIOS
//
//  Created by admin on 02.09.2021.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        switch locationViewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(locationViewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
//            TrackingView()
            TrackingView()
                .environmentObject(locationViewModel)
        default:
            Text("Unexpected status")
        }
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                locationViewModel.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track you.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        ZStack{
            MapView()
            VStack{
                Spacer()
                HStack{
                    Image(systemName: "location.circle")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.blue)
//                        .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                        .rotationEffect(.init(degrees: 60))
                    Spacer()
                }.padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
            }
        }
    }
}
//struct TrackingView: View {
//    @EnvironmentObject var locationViewModel: LocationViewModel
////    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402) , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
////    @State var userTrackingMode: MapUserTrackingMode = .none
////    var map = MapView()
//
//    var body: some View {
//        Text("lat: \(locationViewModel.mapRegion.center.latitude), long: \(locationViewModel.mapRegion.center.longitude). Zoom: \(locationViewModel.mapRegion.span.latitudeDelta)")
//        ZStack {
//            Map(coordinateRegion: $locationViewModel.mapRegion, showsUserLocation: true)
//                    .edgesIgnoringSafeArea(.all)
//                    .gesture(DragGesture().onEnded{ noneed in stopUserTracking() })
////            map
////                .edgesIgnoringSafeArea(.all)
////                .gesture(DragGesture().onEnded{ noneed in map.stopUserTracking(self) })
//            VStack {
//                Spacer()
//                HStack {
//                    Image(systemName: "location.circle")
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                        .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
//                        .rotationEffect(.init(degrees: 70))
//                    Spacer()
//                    VStack {
//                        Image(systemName: "minus.circle")
//                            .font(.system(size: 40))
//                            .onTapGesture {
//                                withAnimation {
//                                    zoomOut()
//                                }
//                        }.padding(5)
//                        Image(systemName: "plus.circle")
//                            .font(.system(size: 40))
//                            .onTapGesture {
//                                withAnimation {
//                                    zoomIn()
//                                }
//                        }.padding(5)
//                        Image(systemName: "location.circle")
//                            .font(.system(size: 40))
//                            .onTapGesture {
//                                userTrackingToggle()
////                                    locationViewModel.userTrackingToggle()
////                                    startUserTracking()
//
//                        }.padding(5)
////                        if locationViewModel.isUserTracking {
////                            Image(systemName: "location.circle")
////                                .font(.system(size: 40))
////                                .onTapGesture {
////                                    withAnimation {
////                                        userTrackingToggle()
////                                    }
////                            }.padding(5)
////                        } else {
////                            Image(systemName: "location.circle")
////                                .font(.system(size: 40))
////                                .onTapGesture {
////                                    withAnimation {
////                                        userTrackingToggle()
////                                    }
////                                }.padding(5).opacity(0.5)
////                        }
//                    }.padding(2)
//                    .foregroundColor(.red)
//                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
//            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
//        }
//    }
//    private func zoomIn() {
////        userTrackingMode = .none
//        locationViewModel.zoomIn()
////        if region.span.latitudeDelta > 10 { region.span.latitudeDelta -= 10 }
////        if region.span.longitudeDelta > 10 { region.span.longitudeDelta -= 10 }
////        mapRegion.span.latitudeDelta *= 0.7
////        mapRegion.span.longitudeDelta *= 0.7
////        print ("ZoomIn \(mapRegion.span.latitudeDelta) : \(mapRegion.span.longitudeDelta)")
//    }
//    private func zoomOut() {
////        userTrackingMode = .none
//        locationViewModel.zoomOut()
////        if region.span.latitudeDelta < 90 { region.span.latitudeDelta += 10 }
////        if region.span.longitudeDelta < 90 { region.span.longitudeDelta += 10 }
////        if (mapRegion.span.latitudeDelta < 100 || mapRegion.span.longitudeDelta < 100) {
////            mapRegion.span.latitudeDelta /= 0.7
////            mapRegion.span.longitudeDelta /= 0.7
////        }
////        print ("ZoomIn \(mapRegion.span.latitudeDelta) : \(mapRegion.span.longitudeDelta)")
//    }
//    private func userTrackingToggle() {
////        if userTrackingMode == .follow {
////            userTrackingMode = .none
////        } else {
////            userTrackingMode = .follow
////        }
////        userTrackingMode = .follow
////        print("View: userTrackingMode: \(locationViewModel.isUserTracking)")
//        locationViewModel.userTrackingToggle()
//    }
////    private func startUserTracking() {
////        userTrackingMode = .follow
////    }
//     private func stopUserTracking() {
//        locationViewModel.stopUserTracking()
////        userTrackingMode = .none
//    }
//
//}
//
//struct MapView: UIViewRepresentable {
//    func makeUIView(context: Context) -> MKMapView {
//        MKMapView(frame: .zero)
//    }
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        let coordinate = CLLocationCoordinate2D(
//            latitude: 51.50007773,
//            longitude: -0.1246402
//        )
//        let span = MKCoordinateSpan(
//            latitudeDelta: 0.05,
//            longitudeDelta: 0.05
//        )
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//        uiView.setRegion(region, animated: true)
//        uiView.showsUserLocation = true
//        uiView.userTrackingMode = .follow
//    }
//    func startUserTracking(_ uiView: MKMapView) {
//        uiView.setUserTrackingMode(.follow, animated: true)
//    }
//    func stopUserTracking(_ uiView: MKMapView) {
//        uiView.setUserTrackingMode(.none, animated: true)
//    }
//}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
        TrackingView()
    }
}
