//
//  GameMode.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

//
//  GameMode.swift
//  Rizzk
//
//  Created by [Your Name] on [Date].
//

import SwiftUI
import Foundation

enum GameMode: String, CaseIterable {
    case host = "host"
    case join = "join"
    
    var displayName: String {
        switch self {
        case .host:
            return "Start Spill"
        case .join:
            return "Join Spill"
        }
    }
    
    var description: String {
        switch self {
        case .host:
            return "Opprett et nytt spill og vent på spillere"
        case .join:
            return "Bli med i et eksisterende spill"
        }
    }
}
