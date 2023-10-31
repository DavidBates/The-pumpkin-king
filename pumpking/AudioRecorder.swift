//
//  AudioRecorder.swift
//  pumpking
//
//  Created by David Bates on 10/8/23.
//

import Foundation
import AVFoundation
import Combine

class AudioRecorder: ObservableObject {
    var audioRecorder: AVAudioRecorder?
    var lastLevelTime: Date?
    var levelTimer: Timer?
    let recordingStopped = PassthroughSubject<URL, Never>()
    let preferences = PreferencesData()
    
    
    func startRecording() {
        let audioFilename = getAppSupportDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            self.audioRecorder?.isMeteringEnabled = true
            self.audioRecorder?.record()
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
        
        self.lastLevelTime = Date().addingTimeInterval(5)
        self.levelTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkAudioLevel), userInfo: nil, repeats: true)
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        if let url = audioRecorder?.url {
                    recordingStopped.send(url)
                }
        audioRecorder = nil
        levelTimer?.invalidate()
        levelTimer = nil
    }
    
    func getAppSupportDirectory() -> URL {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportDirectory = paths[0].appendingPathComponent("pumpking")
        try? FileManager.default.createDirectory(at: appSupportDirectory, withIntermediateDirectories: true, attributes: nil)
        return appSupportDirectory
    }
    
    @objc func checkAudioLevel() {
        guard let recorder = audioRecorder else { return }
        
        recorder.updateMeters()
        
        let power = recorder.averagePower(forChannel: 0)
        print("Current audio level: \(power) dB")
        
        if power < preferences.dbTrigger {  // This threshold might need adjustment dpending on the microphone. 
            lastLevelTime = Date()
        } else if Date().timeIntervalSince(lastLevelTime!) > 2 {  // 2 seconds of silence
            stopRecording()
        }
    }
}
