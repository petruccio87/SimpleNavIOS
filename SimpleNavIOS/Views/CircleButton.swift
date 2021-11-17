//
//  CircleButtonView.swift
//  SimpleNavIOS
//
//  Created by admin on 17.11.2021.
//

import SwiftUI

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

//struct CircleButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircleButtonView(iconName: "location.circle", () -> {} )
//    }
//}
