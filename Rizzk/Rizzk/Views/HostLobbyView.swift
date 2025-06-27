//
//  HostLobbyView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct HostLobbyView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var players: [Player] = []
    @State private var gameCode = "RIZZK1"
    @State private var showingLeaveAlert = false
    @State private var showingKickAlert = false
    @State private var playerToKick: Player?
    @State private var navigateToGame = false
    
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
                    Text("Du er host! 👑")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.drinkYellow)
                    
                    Text("Del spillkoden med vennene dine")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    // Game pack info
                    if let selectedPack = coordinator.selectedGamePack {
                        HStack {
                            Text(selectedPack.icon)
                                .font(.title2)
                            Text(selectedPack.rawValue)
                                .font(.headline)
                                .foregroundColor(.drinkYellow)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                    }
                }
                
                // Game Code Section
                VStack(spacing: 15) {
                    Text("SPILLKODE")
                        .font(.headline)
                        .foregroundColor(.white)
                        .tracking(2)
                    
                    HStack {
                        Text(gameCode)
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundColor(.drinkYellow)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(15)
                        
                        Button(action: copyGameCode) {
                            Image(systemName: "doc.on.doc")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.drinkYellow)
                                .cornerRadius(10)
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
                            // Host (current user)
                            HostPlayerRow(
                                name: coordinator.playerName,
                                isHost: true,
                                onKick: nil
                            )
                            
                            // Other players
                            ForEach(players) { player in
                                HostPlayerRow(
                                    name: player.name,
                                    isHost: false,
                                    onKick: {
                                        playerToKick = player
                                        showingKickAlert = true
                                    }
                                )
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        startGame()
                    }) {
                        GameButton(
                            title: "Start spillet (10 runder)",
                            color: players.count >= 1 ? .drinkYellow : .gray
                        )
                    }
                    .disabled(players.count < 1)
                    
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
            Text("Er du sikker på at du vil forlate lobbyen? Spillet vil bli avsluttet for alle spillere.")
        }
        .alert("Spark ut spiller?", isPresented: $showingKickAlert) {
            Button("Avbryt", role: .cancel) { }
            Button("Spark ut", role: .destructive) {
                if let player = playerToKick {
                    kickPlayer(player)
                }
            }
        } message: {
            Text("Er du sikker på at du vil sparke ut \(playerToKick?.name ?? "")?")
        }
        .navigationDestination(isPresented: $navigateToGame) {
            coordinator.getGameView()
        }
    }
    
    private func copyGameCode() {
        UIPasteboard.general.string = gameCode
        // TODO: Legg til haptic feedback eller toast melding
    }
    
    private func startGame() {
        coordinator.startGame()
        navigateToGame = true
    }
    
    private func kickPlayer(_ player: Player) {
        players.removeAll { $0.id == player.id }
    }
    
    private func setupMockPlayers() {
        // Mock data for testing - fjern når du har ekte data
        players = [
            Player(name: "Alex"),
            Player(name: "Baidakongen"),
            Player(name: "Sossetrynet")
        ]
    }
}

struct HostPlayerRow: View {
    let name: String
    let isHost: Bool
    let onKick: (() -> Void)?
    
    var body: some View {
        HStack {
            HStack(spacing: 10) {
                if isHost {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.drinkYellow)
                } else {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(isHost ? .bold : .medium)
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
            } else if let onKick = onKick {
                Button(action: onKick) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    NavigationStack {
        HostLobbyView()
    }
    .environmentObject(GameCoordinator())
}
