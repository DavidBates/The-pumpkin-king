//
//  OpenAI.swift
//  pumpking
//
//  Created by David Bates on 10/9/23.
//

import Foundation

class OpenAI: ObservableObject {
    private let baseURL = "https://api.openai.com/v1/"
    private let apiKey: String
    let preferences = PreferencesData()
    
    init() {
        if preferences.openAIKey.isEmpty {
            fatalError("API Key not found!")
        }
        self.apiKey = preferences.openAIKey
    }
    
    func uploadAudioToWhisper(audioURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let apiUrl = URL(string: "\(baseURL)audio/transcriptions")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8)!)
        data.append(try! Data(contentsOf: audioURL))
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)  // Corrected this line
        data.append("whisper-1\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = responseData, let responseText = String(data: data, encoding: .utf8) {
                completion(.success(responseText))
            }
        }
        task.resume()
    }

    
    func requestChatCompletion(transcription: String, completion: @escaping (Result<String, Error>) -> Void) {
        let apiUrl = URL(string: "\(baseURL)chat/completions")!
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let messageSystem = [
            "role": "system",
            "content": "I had a conversation with the Pumpkin King, a fictional character brought to life from the soils of Floyd County, VA. The Pumpkin King is a blend of ancient magic and the innocence of the land, towering over other pumpkins, with the wisdom of ages and the mischief of a sprite. He can summon a green flame of wisdom and has an enchantment spell that can trigger a spooky song. He's akin to Jack Skellington but as old as Dracula. His main goal is to pull the fear from those who engage with him, powered by his green flame. The user can trigger a new interaction with the phrase \"Trigger\". Given this background, answer questions and engage in conversations as the Pumpkin King."
        ]
        let messageUser = [
            "role": "user",
            "content": transcription
        ]
        
        let payload = [
            "model": "gpt-4",
            "messages": [messageSystem, messageUser],
            "temperature": 1,
            "max_tokens": 128,
            "top_p": 1,
            "frequency_penalty": 0,
            "presence_penalty": 0
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let choices = json["choices"] as? [[String: Any]], let message = choices.first?["message"] as? [String: Any],
                          let content = message["content"] as? String {
                    completion(.success(content))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
