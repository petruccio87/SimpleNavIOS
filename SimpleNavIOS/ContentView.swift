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
//    @State var isUserTracking = true
    
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402) , span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
//    @State var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        ZStack {
//            Map(coordinateRegion: .constant(locationViewModel.mapRegion), showsUserLocation: true, userTrackingMode: .constant(locationViewModel.userTrackingMode))
            Map(coordinateRegion: .constant(locationViewModel.mapRegion), showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "location.circle")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        .padding(EdgeInsets(top: 30, leading: 30, bottom: 30, trailing: 30))
                        .rotationEffect(.init(degrees: 70))
                    Spacer()
                    VStack {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 40))
                            .onTapGesture {
                                withAnimation {
                                    zoomOut()
                                }
                        }.padding(5)
                        Image(systemName: "plus.circle")
                            .font(.system(size: 40))
                            .onTapGesture {
                                withAnimation {
                                    zoomIn()
                                }
                        }.padding(5)
                        Image(systemName: "location.circle")
                            .font(.system(size: 40))
                            .onTapGesture {
                                withAnimation {
                                    userTrackingToggle()
                                }
                        }.padding(5)
//                        if locationViewModel.isUserTracking {
//                            Image(systemName: "location.circle")
//                                .font(.system(size: 40))
//                                .onTapGesture {
//                                    withAnimation {
//                                        userTrackingToggle()
//                                    }
//                            }.padding(5)
//                        } else {
//                            Image(systemName: "location.circle")
//                                .font(.system(size: 40))
//                                .onTapGesture {
//                                    withAnimation {
//                                        userTrackingToggle()
//                                    }
//                                }.padding(5).opacity(0.5)
//                        }
                    }.padding(2)
                    .foregroundColor(.red)
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
        }
    }
    private func zoomIn() {
//        userTrackingMode = .none
        locationViewModel.zoomIn()
//        if region.span.latitudeDelta > 10 { region.span.latitudeDelta -= 10 }
//        if region.span.longitudeDelta > 10 { region.span.longitudeDelta -= 10 }
    }
    private func zoomOut() {
//        userTrackingMode = .none
        locationViewModel.zoomOut()
//        if region.span.latitudeDelta < 90 { region.span.latitudeDelta += 10 }
//        if region.span.longitudeDelta < 90 { region.span.longitudeDelta += 10 }
    }
    private func userTrackingToggle() {
//        userTrackingMode = .follow
        locationViewModel.userTrackingToggle()
    }

}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
        TrackingView()
    }
}
