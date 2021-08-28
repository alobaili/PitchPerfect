//
//  PitchButton.swift
//  PitchPerfect
//
//  Created by Abdulaziz AlObaili on 28/08/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import SwiftUI

struct PitchButton: View {
    @Environment(\.isEnabled) var isEnabled

    let image: Image
    let size: Double
    let backgroundColor: Color
    let contentColor: Color
    let action: () -> Void

    init(image: Image, size: Double, backgroundColor: Color, contentColor: Color, action: @escaping () -> Void) {
        self.image = image
        self.size = size
        self.backgroundColor = backgroundColor
        self.contentColor = contentColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            image
                .padding(CGFloat(size / 1.5))
                .background(
                    Circle()
                        .fill(Color.cyan)
                        .shadow(radius: 3, y: 2)
                )
        }
        .foregroundColor(Color.cyanContent)
        .font(.system(size: CGFloat(size)))
        .opacity(isEnabled ? 1 : 0.4)
    }
}

struct PitchButton_Previews: PreviewProvider {
    static var previews: some View {
        PitchButton(image: Image(systemName: "mic.fill"), size: 85, backgroundColor: .cyan, contentColor: .cyanContent) {}
    }
}
