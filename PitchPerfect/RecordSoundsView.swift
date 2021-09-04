//
//  RecordSoundsView.swift
//  PitchPerfect
//
//  Created by Abdulaziz AlObaili on 28/08/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import SwiftUI

struct RecordSoundsView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            PitchButton(
                image: Image(systemName: "mic.fill"),
                size: 52,
                backgroundColor: .cyan,
                contentColor: .cyanContent,
                action: viewModel.startRecording
            )
            .disabled(viewModel.isRecording)

            Text(viewModel.labelText)
                .font(.subheadline)

            NavigationLink(
                destination: Text("Destination"),
                isActive: $viewModel.didFinishRecording
            ) {
                PitchButton(
                    image: Image(systemName: "stop.fill"),
                    size: 22,
                    backgroundColor: .cyan,
                    contentColor: .cyanContent,
                    action: viewModel.stopRecording
                )
            }
            .disabled(!viewModel.isRecording)
        }
        .navigationBarHidden(true)
    }
}

struct RecordSoundsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecordSoundsView()
        }
    }
}
