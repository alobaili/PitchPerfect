//
//  RecordSoundsView.swift
//  PitchPerfect
//
//  Created by Abdulaziz AlObaili on 28/08/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import SwiftUI

struct RecordSoundsView: View {
    var body: some View {
        VStack {
            PitchButton(image: Image(systemName: "mic.fill"), size: 52, backgroundColor: .cyan, contentColor: .cyanContent) {

            }

            Text("Tap to Record")
                .font(.subheadline)

            PitchButton(image: Image(systemName: "stop.fill"), size: 22, backgroundColor: .cyan, contentColor: .cyanContent) {

            }
            .disabled(true)
        }
    }
}

struct RecordSoundsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordSoundsView()
    }
}
