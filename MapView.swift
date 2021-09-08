//
//  MapView.swift
//  SimpleNavIOS
//
//  Created by admin on 08.09.2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 25.7617,
            longitude: 80.1918
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 10,
            longitudeDelta: 10
        )
    )
    
    var isUserTracking: Bool {
        get {
            if userTrackingMode == .follow {
                return true
                
            } else {
                return false
                
            }
        }
    }
    
    func toggleTrack() {
        if userTrackingMode == .follow {
            userTrackingMode = .none
        } else {
            userTrackingMode = .follow
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
        if (region.span.latitudeDelta < 150 || region.span.longitudeDelta < 150) {
            region.span = MKCoordinateSpan(
                latitudeDelta: region.span.latitudeDelta / 0.7,
                longitudeDelta: region.span.longitudeDelta / 0.7
            )
        }
        print ("ZoomIn \(region.span.latitudeDelta) : \(region.span.longitudeDelta)")
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode
                ).edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    VStack{
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
                                withAnimation{
                                    toggleTrack()
                                }
                            }
                            .padding(5)
                            .opacity(isUserTracking ? 1 : 0.6)
                    }.padding(.trailing, 20)
                }.padding(.bottom, 100)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
