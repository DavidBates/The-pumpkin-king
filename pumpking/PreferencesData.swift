//
//  PreferencesData.swift
//  pumpking
//
//  Created by David Bates on 10/30/23.
//

import Foundation

class PreferencesData: ObservableObject {
    @Published var openAIKey: String {
        didSet {
            UserDefaults.standard.set(openAIKey, forKey: "openAIKey")
            if self.dbTrigger == 0 {
                        self.dbTrigger = -40.0 // Default to -40dB
                    }
        }
    }
    @Published var elevenLabsKey: String {
        didSet {
            UserDefaults.standard.set(elevenLabsKey, forKey: "elevenLabsKey")
        }
    }
    @Published var dbTrigger: Double {
            didSet {
                UserDefaults.standard.set(dbTrigger, forKey: "dbTrigger")
            }
        }
    
    init() {
        self.openAIKey = UserDefaults.standard.string(forKey: "openAIKey") ?? ""
        self.elevenLabsKey = UserDefaults.standard.string(forKey: "elevenLabsKey") ?? ""
        self.dbTrigger = UserDefaults.standard.double(forKey: "dbTrigger")
    }
}

