//
//  PreferencesView.swift
//  pumpking
//
//  Created by David Bates on 10/30/23.
//

import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences = PreferencesData()
    
    var body: some View {
        Form {
            TextField("OpenAI API Key", text: $preferences.openAIKey)
            TextField("Eleven Labs API Key", text: $preferences.openAIKey)
            Slider(value: $preferences.dbTrigger, in: -80...0, step: 1) // Slider ranging from -80 to 0
                            .padding(.top, 10)
                        Text("dB Trigger: \(preferences.dbTrigger, specifier: "%.0f") dB")
                            .font(.caption)
        }
        .padding()
        .frame(width: 300, height: 150)
    }
}

