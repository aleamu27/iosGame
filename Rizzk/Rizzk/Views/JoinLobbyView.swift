//
//  JoinLobbyView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct JoinLobbyView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var players: [Player] = []
    @State private var hostName = "Andy"
    @State private var showingLeaveAlert = false
    @State private var navigateToGame = false
    @State private var connectionStatus: ConnectionStatus = .connected
    
    enum ConnectionStatus {
        case connecting
        case connected
        case disconnected
        
        var text: String {
            switch self {
            case .connecting:
                return "Kobler til..."
            case .connected:
                return "Tilkoblet"
            case .disconnected:
                return "Frakoblet"
            }
        }
        
        var color: Color {
            switch self {
            case .connecting:
                return .yellow
            case .connected:
                return .green
            case .disconnected:
                return .red
            }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkBlue, Color.drinkGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 15) {
                    Text("Venter på spillet...")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(connectionStatus.color)
                            .frame(width: 12, height: 12)
                        
                        Text(connectionStatus.text)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                // Game Info Section
                VStack(spacing: 15) {
                    VStack(spacing: 8) {
                        Text("SPILLKODE")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                            .tracking(2)
                        
                        Text(coordinator.gameCode)
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                            .foregroundColor(.drinkYellow)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                    }
                    
                    VStack(spacing: 8) {
                        Text("HOST")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                            .tracking(2)
                        
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.drinkYellow)
                            Text(hostName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(20)
                
                // Players Section
                VStack(spacing: 15) {
                    HStack {
                        Text("Spillere i lobbyen")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(players.count + 1)/8")
                            .font(.headline)
                            .foregroundColor(.drinkYellow)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            // Host
                            JoinPlayerRow(
                                name: hostName,
                                isHost: true,
                                isCurrentUser: false
                            )
                            
                            // Current user
                            JoinPlayerRow(
                                name: coordinator.playerName,
                                isHost: false,
                                isCurrentUser: true
                            )
                            
                            // Other players
                            ForEach(players) { player in
                                JoinPlayerRow(
                                    name: player.name,
                                    isHost: false,
                                    isCurrentUser: false
                                )
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                
                Spacer()
                
                // Status Message
                VStack(spacing: 10) {
                    Text("⏳ Venter på at host starter spillet")
                        .font(.headline)
                        .foregroundColor(.drinkYellow)
                        .multilineTextAlignment(.center)
                    
                    Text("Du vil automatisk bli sendt videre når spillet starter")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                
                // Leave Button
                Button(action: {
                    showingLeaveAlert = true
                }) {
                    HStack {
                        Image(systemName: "xmark.circle")
                        Text("Forlat lobbyen")
                    }
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color.red.opacity(0.7))
                    .cornerRadius(15)
                }
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            setupMockPlayers()
        }
        .alert("Forlat lobbyen?", isPresented: $showingLeaveAlert) {
            Button("Avbryt", role: .cancel) { }
            Button("Forlat", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Er du sikker på at du vil forlate lobbyen?")
        }
        .navigationDestination(isPresented: $navigateToGame) {
            // TODO: Bytt til din faktiske game view
            Text("Game Started!")
                .font(.title)
                .foregroundColor(.white)
        }
    }
    
    private func setupMockPlayers() {
        // Mock data for testing - fjern når du har ekte data
        players = [
            Player(name: "Baidakongen"),
            Player(name: "Sossetrynet")
        ]
    }
}

struct JoinPlayerRow: View {
    let name: String
    let isHost: Bool
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                if isHost {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.drinkYellow)
                } else if isCurrentUser {
                    Image(systemName: "person.fill")
                        .foregroundColor(.drinkYellow)
                } else {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(isHost || isCurrentUser ? .bold : .medium)
            }
            
            Spacer()
            
            if isHost {
                Text("HOST")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.drinkYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.drinkYellow.opacity(0.2))
                    .cornerRadius(8)
            } else if isCurrentUser {
                Text("DEG")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.drinkYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.drinkYellow.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(isCurrentUser ? 0.15 : 0.1))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isCurrentUser ? Color.drinkYellow.opacity(0.5) : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        JoinLobbyView()
    }
    .environmentObject(GameCoordinator())
}
