//
//  ContentView.swift
//  pumpking
//
//  Created by David Bates on 10/7/23.
//
import SwiftUI

enum AppState {
    case idle
    case active
}

struct ContentView: View {
    @State private var currentState: AppState = .idle
    @ObservedObject var keyPressHandler = KeyPressHandler()
    @ObservedObject var playbackViewModel = PlaybackViewModel()
    @ObservedObject var bleManager = BLEManager()

    var body: some View {
        ZStack {
            IdleView(isPlayingModel: playbackViewModel)
            if currentState == .active {
                ActiveView(returnToIdle: toggleToIdle)
            }
        }
        .onReceive(keyPressHandler.keyPressSubject) { key in
            if key == "ToggleMode" {
                toggleState()
            }
        }
        .onReceive(bleManager.$isPersonDetected) { detected in
            
            if detected {
                self.playbackViewModel.isPlaying = false
                currentState = .active
            } 
        }
        .onAppear {
            monitorKeyPress()
        }
    }

    func monitorKeyPress() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let currentTime = Date()
                        
            if let lastTime = self.keyPressHandler.lastKeyPressTime, currentTime.timeIntervalSince(lastTime) < self.keyPressHandler.keyPressCooldown {
                // It's too soon after the last keypress, so ignore this one
                return event
            }
            if event.modifierFlags.contains([.control]) && event.characters == "\u{07}" {
                self.keyPressHandler.keyPressSubject.send("ToggleMode")
                self.keyPressHandler.lastKeyPressTime = currentTime
                return nil
            }
            return event
        }
    }

    func toggleState() {
        if currentState == .idle {
            self.playbackViewModel.isPlaying = false
            currentState = .active
        } else {
            self.playbackViewModel.isPlaying = true
            currentState = .idle
        }
    }
    func toggleToIdle() {
           self.playbackViewModel.isPlaying = true
           currentState = .idle
       }
}

class PlaybackViewModel: ObservableObject {
    @Published var isPlaying: Bool = true
}

