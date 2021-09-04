//
//  RecordSoundsViewModel.swift
//  PitchPerfect
//
//  Created by Abdulaziz AlObaili on 04/09/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import SwiftUI
import AVFoundation

extension RecordSoundsView {
    class ViewModel: NSObject, ObservableObject {
        @Published var isRecording = false
        @Published var didFinishRecording = false

        var labelText: LocalizedStringKey {
            if isRecording {
                return LocalizedStringKey("Recording in progress...")
            } else {
                return LocalizedStringKey("Tap to record")
            }
        }

        var audioRecorder: AVAudioRecorder!

        func startRecording() {
            isRecording = true

            do {
                let documentsDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                     in: .userDomainMask,
                                                                     appropriateFor: nil,
                                                                     create: true)
                let recordingName = "recording.wav"
                let fileURL = documentsDirectory.appendingPathComponent(recordingName)

                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
                try audioRecorder = AVAudioRecorder(url: fileURL, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
            } catch {
                print("An error occured while recording audio: \(error)")
            }
        }

        func stopRecording() {
            isRecording = false
            
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch {
                print("An error occured while stopping recording audio: \(error)")
            }
        }
    }
}

extension RecordSoundsView.ViewModel: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        didFinishRecording = flag
    }
}
