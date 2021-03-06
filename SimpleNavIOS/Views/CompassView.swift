//
//  CompassView.swift
//  SimpleNavIOS
//
//  Created by admin on 13.09.2021.
//

import SwiftUI

struct CopmassView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var angle: Double = 0
    
    var body: some View {
//        Toggle("Demo heading", isOn: $locationViewModel.isDemoHeading)
//        Slider(value: $angle, in: 0...360)
        Image(systemName: "location.circle")
            .resizable()
            .frame(width: 150, height: 150)
            .foregroundColor(isItRightWay() ? .green : .blue)
            .onReceive(locationViewModel.$heading) { _ in
                let angle = locationViewModel.directionToPoint
                    withAnimation(.easeInOut(duration: 0.2)) {
                      self.angle = Double(angle ?? 0)
                    }
                  }
            .rotationEffect(.degrees(angle - 45))
        //            .modifier(rotationEffect(Angle(degrees: 0)) )
//            .rotationEffect(.degrees(locationViewModel.directionToPoint ?? 30))
    }
    
    func isItRightWay() -> Bool {
        guard let angle = locationViewModel.directionToPoint?.truncatingRemainder(dividingBy: 360) else { return false }
        if angle < 10, angle > -10 { return true }
        else { return false }
    }
}
