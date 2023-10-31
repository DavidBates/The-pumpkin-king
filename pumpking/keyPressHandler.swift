//
//  keyPressHandler.swift
//  pumpking
//
//  Created by David Bates on 10/7/23.
//

import SwiftUI
import Combine

class KeyPressHandler: ObservableObject {
    let keyPressSubject = PassthroughSubject<String, Never>()
    var lastKeyPressTime: Date? = nil 
    let keyPressCooldown = 3.0
}

