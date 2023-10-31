//
//  VoiceSynthesizer.swift
//  pumpking
//
//  Created by David Bates on 10/9/23.
//

import Foundation
import Combine

class VoiceSynthesizer: ObservableObject {
    private let baseURL = "https://api.elevenlabs.io/v1/text-to-speech/"
    private let modelID = "eleven_multilingual_v2"
    private let voiceID: String
    private let apiKey: String
    let preferences = PreferencesData()
    
    @Published var audioData: Data = Data()
    
    init() {
        if preferences.elevenLabsKey.isEmpty {
            fatalError("API Key not found!")
        }
        if preferences.elevenLabsVoiceID.isEmpty {
            fatalError("VoiceID not found!")
        }
        self.apiKey = preferences.elevenLabsKey
        self.voiceID = preferences.elevenLabsVoiceID
    }
    
    func synthesize(text: String) {
        let url = URL(string: "\(baseURL)\(voiceID)?optimize_streaming_latency=1")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("audio/mpeg", forHTTPHeaderField: "accept")
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "text": text,
            "model_id": modelID,
            "voice_settings": ["stability": 0.3, "similarity_boost": 0.75]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error while fetching audio: \(error.localizedDescription)")  // Debug print
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.audioData = data
                }
            }
        }
        
        task.resume()
    }
}
