//
//  CompassView.swift
//  SimpleNavIOS
//
//  Created by admin on 13.09.2021.
//

import SwiftUI

struct CopmassView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State var angle: Double = 0
    
    var body: some View {
        Slider(value: $angle, in: 0...360)
        Image(systemName: "location.circle")
            .resizable()
            .frame(width: 150, height: 150)
            .foregroundColor(.blue)
            .onReceive(locationViewModel.$heading) { heading in
                    withAnimation(.easeInOut(duration: 0.2)) {
                      self.angle = Double(heading ?? 0)
                    }
                  }
            .rotationEffect(.degrees(angle))
        //            .modifier(rotationEffect(Angle(degrees: 0)) )
//            .rotationEffect(.degrees(locationViewModel.directionToPoint ?? 30))
    }
}
