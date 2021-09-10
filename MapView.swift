//
//  MapView.swift
//  SimpleNavIOS
//
//  Created by admin on 08.09.2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var userTrackingMode: MKUserTrackingMode = .followWithHeading
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.759351,
            longitude: -122.446913
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 10,
            longitudeDelta: 10
        )
    )
    
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
        if userTrackingMode == .followWithHeading {
            userTrackingMode = .none
        } else {
            userTrackingMode = .followWithHeading
        }
    }
    func zoomIn() {
        region.span = MKCoordinateSpan(
            latitudeDelta: region.span.latitudeDelta * 0.7,
            longitudeDelta: region.span.longitudeDelta * 0.7
        )
        print ("ZoomIn \(region.span.latitudeDelta) : \(region.span.longitudeDelta)")
    }
    func zoomOut() {
        if (region.span.latitudeDelta < 100 || region.span.longitudeDelta < 100) {
            region.span = MKCoordinateSpan(
                latitudeDelta: region.span.latitudeDelta / 0.7,
                longitudeDelta: region.span.longitudeDelta / 0.7
            )
        }
        print ("ZoomOut \(region.span.latitudeDelta) : \(region.span.longitudeDelta)")
    }

    var body: some View {

        ZStack {
            MyMKMapView(region: $region, userTrackingMode: $userTrackingMode, annotations: locationViewModel.destPins)
                .edgesIgnoringSafeArea(.all)
            #if DEBUG
            Text("lat: \(region.center.latitude) lng: \(region.center.longitude) zoom: \(region.span.latitudeDelta) Track: \(userTrackingMode.rawValue)")
            #endif
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    VStack{
                        CircleButton(iconName: "minus.circle") { zoomOut() }
                        CircleButton(iconName: "plus.circle") { zoomIn() }
                        CircleButton(iconName: "location.circle") { toggleTrack() }
                            .opacity(isUserTracking ? 1 : 0.6)
                    }.padding(.trailing, 20)
                }.padding(.bottom, 100)
            }
        }
    }
}

struct CircleButton: View {
    var action: () -> Void
    var iconName: String
    
    init(iconName: String, _ action: @escaping () -> Void) {
        self.action = action
        self.iconName = iconName
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Image(systemName: iconName)
        }
        .padding(10)
        .background(Color.black.opacity(0.75))
        .foregroundColor(.white)
        .font(.title)
        .clipShape(Circle())
    }
}









struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
