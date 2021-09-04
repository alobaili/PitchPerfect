//
//  PlaySoundsView.swift
//  PitchPerfect
//
//  Created by Abdulaziz AlObaili on 04/09/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import SwiftUI

struct PlaySoundsView: View {
    enum ButtonType: Int {
        case slow, fast, chipmunk, vader, echo, reverb
    }
    
    let url: URL
    @StateObject private var viewModel: ViewModel

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    init(url: URL) {
        self.url = url
        _viewModel = StateObject(wrappedValue: ViewModel(recordedAudioURL: url))
    }

    var body: some View {
        VStack(spacing: 60) {
            LazyVGrid(columns: columns, spacing: 60) {
                Button {
                    playSound(for: .slow)
                } label: {
                    Image("Slow")
                }

                Button {
                    playSound(for: .fast)
                } label: {
                    Image("Fast")
                }

                Button {
                    playSound(for: .chipmunk)
                } label: {
                    Image("HighPitch")
                }

                Button {
                    playSound(for: .vader)
                } label: {
                    Image("LowPitch")
                }

                Button {
                    playSound(for: .echo)
                } label: {
                    Image("Echo")
                }

                Button {
                    playSound(for: .reverb)
                } label: {
                    Image("Reverb")
                }
            }
            .opacity(viewModel.playingState == .playing ? 0.5 : 1)
            .disabled(viewModel.playingState == .playing)

            PitchButton(
                image: Image(systemName: "stop.fill"),
                size: 28,
                backgroundColor: .cyan,
                contentColor: .cyanContent,
                action: viewModel.stopAudio
            )
            .disabled(viewModel.playingState == .notPlaying)
        }
        .onAppear(perform: viewModel.setupAudio)
    }

    func playSound(for type: ButtonType) {
        switch type {
            case .slow: viewModel.playSound(rate: 0.5)
            case .fast: viewModel.playSound(rate: 1.5)
            case .chipmunk: viewModel.playSound(pitch: 1000)
            case .vader: viewModel.playSound(pitch: -1000)
            case .echo: viewModel.playSound(echoed: true)
            case .reverb: viewModel.playSound(reverbed: true)
        }

        viewModel.playingState = .playing
    }
}

struct PlaySoundsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaySoundsView(url: URL(string: "example.com")!)
    }
}
