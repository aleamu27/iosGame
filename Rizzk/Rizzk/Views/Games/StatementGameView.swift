//
//  StatementGameView.swift
//  Rizzk
//
//  Created by Alexander Amundsen on 25/06/2025.
//

import SwiftUI

struct StatementGameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: GameCoordinator
    @State private var currentStatement = "Hvem ville mest sannsynlig våknet opp i Vegas gift med en fremmed?"
    @State private var selectedPlayers: [String] = []
    @State private var votes: [String: Int] = [:]
    @State private var hasVoted = false
    @State private var showResults = false
    @State private var winner: String?
    @State private var navigateToCompleted = false
    
    // Mock players - replace with real data
    @State private var allPlayers = ["Alex", "Emma", "Lars", "Sofia", "Marcus"]
    
    // Computed property for progress
    private var roundProgress: Double {
        guard coordinator.totalRounds > 0 else { return 0.0 }
        return Double(coordinator.currentRound) / Double(coordinator.totalRounds)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.drinkPink, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header with round info
                VStack(spacing: 15) {
                    HStack {
                        Text("👥")
                            .font(.largeTitle)
                        Text("PÅSTAND")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Round progress
                    VStack(spacing: 10) {
                        ProgressView(value: roundProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .drinkYellow))
                            .scaleEffect(x: 1, y: 2)
                        
                        Text("Runde \(coordinator.currentRound) av \(coordinator.totalRounds)")
                            .font(.headline)
                            .foregroundColor(.drinkYellow)
                    }
                    
                    Text("Pakke: \(coordinator.selectedGamePack?.rawValue ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                }
                
                // Statement card
                VStack(spacing: 20) {
                    Text(currentStatement)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(20)
                    
                    if !showResults {
                        // Instructions
                        VStack(spacing: 10) {
                            Text("🗳️ STEM PÅ EN AV DE TO")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.drinkYellow)
                            
                            Text("Hvem passer påstanden best på?")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                    }
                }
                
                if !showResults {
                    // Player selection for voting
                    VStack(spacing: 20) {
                        Text("Valgte spillere:")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 30) {
                            ForEach(selectedPlayers, id: \.self) { player in
                                VStack(spacing: 15) {
                                    // Player avatar
                                    Circle()
                                        .fill(Color.drinkYellow)
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Text(String(player.prefix(1)).uppercased())
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                                    
                                    Text(player)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    if !hasVoted {
                                        Button(action: {
                                            vote(for: player)
                                        }) {
                                            Text("STEM")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 10)
                                                .background(Color.drinkPink)
                                                .cornerRadius(25)
                                        }
                                    } else {
                                        Text("Stemmer: \(votes[player] ?? 0)")
                                            .font(.subheadline)
                                            .foregroundColor(.drinkYellow)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 8)
                                            .background(Color.white.opacity(0.2))
                                            .cornerRadius(15)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    // Results view
                    VStack(spacing: 25) {
                        Text("🏆 RESULTAT")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.drinkYellow)
                        
                        if let winner = winner {
                            VStack(spacing: 15) {
                                Circle()
                                    .fill(Color.drinkYellow)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Text(String(winner.prefix(1)).uppercased())
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Text(winner)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("må drikke \(coordinator.getDrinkPrompt(sips: 3))")
                                    .font(.title2)
                                    .foregroundColor(.drinkYellow)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 15) {
                    if showResults {
                        VStack(spacing: 10) {
                            Button(action: {
                                coordinator.nextRound()
                                if coordinator.isGameFinished {
                                    navigateToCompleted = true
                                } else {
                                    generateNewStatement()
                                }
                            }) {
                                GameButton(
                                    title: coordinator.currentRound < coordinator.totalRounds ?
                                        "Neste runde" : "Se resultat!",
                                    color: .drinkGreen
                                )
                            }
                            
                            Button(action: {
                                coordinator.endGame()
                                dismiss()
                            }) {
                                Text("Tilbake til lobby")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(15)
                            }
                        }
                    } else if hasVoted {
                        Button(action: {
                            showResults = true
                            determineWinner()
                        }) {
                            GameButton(title: "Se resultat", color: .drinkYellow)
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            generateNewStatement()
        }
        .navigationDestination(isPresented: $navigateToCompleted) {
            GameCompletedView()
        }
    }
    
    private func vote(for player: String) {
        votes[player, default: 0] += 1
        hasVoted = true
    }
    
    private func determineWinner() {
        winner = votes.max { $0.value < $1.value }?.key
    }
    
    private func generateNewStatement() {
        // Mock statements - replace with backend data
        let statements = [
            "Hvem ville mest sannsynlig våknet opp i Vegas gift med en fremmed?",
            "Hvem ville mest sannsynlig blitt influencer?",
            "Hvem ville aldri klart å bo alene?",
            "Hvem ville mest sannsynlig blitt arrestert for noe dumt?",
            "Hvem ville overlevd lengst på en øde øy?",
            "Hvem ville mest sannsynlig blitt berømt?",
            "Hvem ville mest sannsynlig startet en YouTube-kanal?",
            "Hvem ville overlatt gruppen i en nødsituasjon?",
            "Hvem ville mest sannsynlig blitt millionær før 30?",
            "Hvem ville aldri klart å holde en hemmelighet?"
        ]
        
        currentStatement = statements.randomElement() ?? "Hvem ville mest sannsynlig blitt berømt?"
        
        // Select 2 random players
        selectedPlayers = Array(allPlayers.shuffled().prefix(2))
        votes.removeAll()
        hasVoted = false
        showResults = false
        winner = nil
    }
}

#Preview {
    NavigationStack {
        StatementGameView()
    }
    .environmentObject(GameCoordinator())
}
