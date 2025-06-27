//
//  Player.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import Foundation
import UIKit

struct Player: Identifiable, Codable {
    let id: String
    let name: String
    
    init(id: String? = nil, name: String) {
        self.id = id ?? UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        self.name = name
    }
}
