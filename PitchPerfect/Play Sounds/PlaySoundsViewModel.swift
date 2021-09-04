//
//  PlaySoundsViewModel.swift
//  PitchPerfect
//
//  Created by Abdulaziz AlObaili on 04/09/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import Combine
import AVFoundation

extension PlaySoundsView {
    class ViewModel: NSObject, ObservableObject {
        // MARK: Alert

        struct Alert {
            static let dismiss = "Dismiss"
            static let recordingDisabledTitle = "Recording Disabled"
            static let recordingDisabledMessage = "You've disabled this app from recording your " +
                "microphone. Check Settings."
            static let recordingFailedTitle = "Recording Failed"
            static let recordingFailedMessage = "Something went wrong with your recording."
            static let audioRecorderError = "Audio Recorder Error"
            static let audioSessionError = "Audio Session Error"
            static let audioRecordingError = "Audio Recording Error"
            static let audioFileError = "Audio File Error"
            static let audioEngineError = "Audio Engine Error"
        }

        // MARK: PlayingState

        enum PlayingState { case playing, notPlaying }
        @Published var playingState = PlayingState.notPlaying

        var recordedAudioURL: URL
        var audioFile: AVAudioFile!
        var audioEngine: AVAudioEngine!
        var audioPlayerNode: AVAudioPlayerNode!
        var stopTimer: Timer!

        var alertTitle = ""
        var alertMessage = ""

        @Published var showingAlert = false

        init(recordedAudioURL: URL) {
            self.recordedAudioURL = recordedAudioURL
            super.init()
        }

        // MARK: Audio Functions

        func setupAudio() {
            do {
                audioFile = try AVAudioFile(forReading: recordedAudioURL)
            } catch {
                showAlert(title: Alert.audioFileError, message: String(describing: error))
            }
        }

        func playSound(rate: Float? = nil,
                       pitch: Float? = nil,
                       echoed: Bool = false,
                       reverbed: Bool = false) {
            // initialize audio engine components
            audioEngine = AVAudioEngine()

            // node for playing audio
            audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attach(audioPlayerNode)

            // node for adjusting rate/pitch
            let changeRatePitchNode = AVAudioUnitTimePitch()

            if let pitch = pitch {
                changeRatePitchNode.pitch = pitch
            }

            if let rate = rate {
                changeRatePitchNode.rate = rate
            }

            audioEngine.attach(changeRatePitchNode)

            // node for echo
            let echoNode = AVAudioUnitDistortion()
            echoNode.loadFactoryPreset(.multiEcho1)
            audioEngine.attach(echoNode)

            // node for reverb
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset(.cathedral)
            reverbNode.wetDryMix = 50
            audioEngine.attach(reverbNode)

            // connect nodes
            if echoed && reverbed {
                connectAudioNodes(audioPlayerNode,
                                  changeRatePitchNode,
                                  echoNode,
                                  reverbNode,
                                  audioEngine.outputNode)
            } else if echoed {
                connectAudioNodes(audioPlayerNode,
                                  changeRatePitchNode,
                                  echoNode,
                                  audioEngine.outputNode)
            } else if reverbed {
                connectAudioNodes(audioPlayerNode,
                                  changeRatePitchNode,
                                  reverbNode,
                                  audioEngine.outputNode)
            } else {
                connectAudioNodes(audioPlayerNode,
                                  changeRatePitchNode,
                                  audioEngine.outputNode)
            }

            // schedule to play and start the engine!
            audioPlayerNode.stop()
            audioPlayerNode.scheduleFile(audioFile, at: nil) {
                var delayInSeconds: Double = 0

                if let lastRenderTime = self.audioPlayerNode.lastRenderTime,
                   let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                    if let rate = rate {
                        delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) /
                            Double(self.audioFile.processingFormat.sampleRate) /
                            Double(rate)
                    } else {
                        delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) /
                            Double(self.audioFile.processingFormat.sampleRate)
                    }
                }

                // schedule a stop timer for when audio finishes playing
                self.stopTimer = Timer(timeInterval: delayInSeconds,
                                       target: self,
                                       selector: #selector(self.stopAudio),
                                       userInfo: nil,
                                       repeats: false)
                RunLoop.main.add(self.stopTimer!, forMode: .default)
            }

            do {
                try audioEngine.start()
            } catch {
                showAlert(title: Alert.audioEngineError, message: String(describing: error))
                return
            }

            // play the recording!
            audioPlayerNode.play()
        }

        @objc func stopAudio() {
            if let audioPlayerNode = audioPlayerNode {
                audioPlayerNode.stop()
            }

            if let stopTimer = stopTimer {
                stopTimer.invalidate()
            }

            playingState = .notPlaying

            if let audioEngine = audioEngine {
                audioEngine.stop()
                audioEngine.reset()
            }
        }

        // MARK: Connect List of Audio Nodes

        func connectAudioNodes(_ nodes: AVAudioNode...) {
            for x in 0..<nodes.count - 1 {
                audioEngine.connect(nodes[x], to: nodes[x + 1], format: audioFile.processingFormat)
            }
        }

        func showAlert(title: String, message: String) {
            alertTitle = title
            alertMessage = message
            showingAlert = true
        }
    }
}
