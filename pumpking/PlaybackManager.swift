//
//  PlaybackManager.swift
//  pumpking
//
//  Created by David Bates on 10/8/23.
//

import Foundation
import AVFoundation
import Combine

class PlaybackManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    let playbackFinished = PassthroughSubject<Void, Never>()
    
    func play(url: URL) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.delegate = self
            self.player?.play()
            print("Audio started playing.")  // Debug print
        } catch {
            print("Error playing audio: \(error.localizedDescription)")  // Debug print
        }
    }
    
    func play(data: Data) {
        do {
            self.player = try AVAudioPlayer(data: data)
            self.player?.delegate = self
            self.player?.play()
            print("Audio data started playing.")  // Debug print
        } catch {
            print("Error playing audio data: \(error.localizedDescription)")  // Debug print
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playbackFinished.send(())
    }
}
