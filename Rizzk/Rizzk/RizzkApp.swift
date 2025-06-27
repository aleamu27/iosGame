//
//  RizzkApp.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

@main
struct RizzkApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GameCoordinator())
        }
    }
}
