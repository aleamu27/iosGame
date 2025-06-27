//
//  ContentView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            StartGameView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GameCoordinator())
}
